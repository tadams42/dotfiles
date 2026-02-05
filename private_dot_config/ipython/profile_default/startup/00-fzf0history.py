from __future__ import annotations

import subprocess
from typing import TYPE_CHECKING

from IPython import get_ipython
from prompt_toolkit.application import run_in_terminal
from prompt_toolkit.keys import Keys

if TYPE_CHECKING:
    from IPython.terminal.interactiveshell import TerminalInteractiveShell
    from prompt_toolkit.buffer import Buffer
    from prompt_toolkit.key_binding import KeyBindings
    from prompt_toolkit.key_binding.key_processor import KeyPressEvent


LOAD_MAX_HISTORY_LINES_COUNT = 3000


def _load_ipy_history() -> str:
    # Get all history (newest first, unique)
    ip: TerminalInteractiveShell = get_ipython()
    history_set = set()
    history_list = []
    # Fetch history from SQLite
    for _, _, line in reversed(
        ip.history_manager.get_tail(LOAD_MAX_HISTORY_LINES_COUNT)
    ):
        line = line.strip()
        if line and line not in history_set:
            history_list.append(line)
            history_set.add(line)
    return "\0".join(history_list)


def _construct_fzf_command(current_prompt: str | None = None):
    retv = [
        "fzf",
        "--read0",
        "--no-sort",
        "--height",
        "45%",
        "--reverse",
        "--border",
        "rounded",
        "--header",
        "IPython History",
        "--prompt",
        "🐍 > ",
    ]

    # PASS THE QUERY: This seeds fzf with whatever you already typed in Ipython
    # prompt
    if current_prompt:
        retv.extend(["--query", current_prompt])

    retv.extend(
        [
            # "--color=dark,fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe",
            # "--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b",
            "--preview",
            "echo {} | bat --language=python --color=always --style=plain",
            "--preview-window",
            "up:3:wrap",
        ]
    )

    return retv


def _run_fzf(current_prompt: str) -> str:
    history_str = _load_ipy_history()
    fzf_cmd = _construct_fzf_command(current_prompt)
    try:
        fzf = subprocess.Popen(
            fzf_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True
        )
        stdout, _ = fzf.communicate(input=history_str)
        if fzf.returncode == 0 and stdout:
            return stdout.strip()
    except FileNotFoundError:
        print("\nError: 'fzf' or 'bat' not found.")
    return ""


ip: TerminalInteractiveShell = get_ipython()
if getattr(ip, "pt_app", None):
    registry: KeyBindings = ip.pt_app.key_bindings

    @registry.add(Keys.ControlR)
    async def fzf_history_search(event: KeyPressEvent):
        new_text = await run_in_terminal(lambda: _run_fzf(event.current_buffer.text))
        if new_text:
            buffer: Buffer = event.current_buffer
            buffer.text = new_text
            buffer.cursor_position = len(buffer.text)
