
if !has('lua')
    echo "Error: requires vim compiled with +lua."
    finish
endif

function! REPLize()
    lua replize.replize()
endfunction

lua << EOF
local package = {}
replize = package

-- Imports
local os = os
local string = string
local vim = vim

-- Package
_ENV = package

function replize()
    local ft = vim.eval("&filetype")

    -- Pre-execution hook.
    call_hook(ft, "pre")

    local text = vim.line()

    -- Processing hook.
    text = call_hook(ft, "proc", text)
    send_tmux(text)

    -- Post-execution hook.
    call_hook(ft, "post")
end

function send_tmux(text)
    -- Sends specified text to tmux.
    text = string.gsub(text, "'", "'\\''")
    text = "tmux send-keys -l '" .. text .. "'"
    os.execute(text)
    os.execute("tmux send-keys C-m")
    -- Fix redraw bug.
    vim.command("redraw!")
end

function call_hook(filetype, mode, arg)
    base = mode .. "_hook"

    -- Check whether the specified hook exists; otherwise, use default.
    hook = _ENV[filetype .. "_" .. base]
    if not hook then hook = _ENV[base] end

    return hook(arg)
end

function pre_hook()
    -- Default pre_hook().
    -- Do nothing.
end

function proc_hook(text)
    -- Default proc_hook().
    return text
end

function post_hook()
    -- Default post_hook().
    vim.command("normal j")
end

return package
EOF

