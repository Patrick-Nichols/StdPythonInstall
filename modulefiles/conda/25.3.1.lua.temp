
local conda_dir = INSTALL_PREFIX
--prepend_path("PATH", pathJoin(conda_dir,"bin"))
--prepend_path("PATH", pathJoin(conda_dir,"condabin"))
if ( myShellType() == "csh") then
   local conda_cmd=pathJoin(conda_dir,"/etc/profile.d/conda.csh")
   execute{cmd="source "..conda_cmd..";source "..conda_cmd.." activate", modeA={"load"}}
else
   execute{cmd="source '"..pathJoin(conda_dir, "etc/profile.d/conda."..myShellType()).."'; conda activate base", modeA={"load"}}
end

-- **unload**
if (mode() == "unload") then
    -- When starting an interactive session, the unload script is run when
    -- conda is not yet initalized. This causes unncessary warnings to be
    -- printed. Thus stderr is suppressed to avoid confusion
    local deactivate = ""
    if (myShellType() == "sh") then
        deactivate = "conda deactivate 2> /dev/null"
    end
    if (myShellType() == "csh") then
        deactivate = "conda deactivate >& /dev/null"
    end
    local shell_level = tonumber(os.getenv("CONDA_SHLVL"))
    for i = shell_level, 1, -1 do
        execute {
            cmd = deactivate,
            modeA = {"unload"}
        }
    end 
    remove_path("PATH", pathJoin(conda_dir, "bin"))
    remove_path("PATH", pathJoin(conda_dir, "condabin"))
end
vars = {"__add_sys_prefix_to_path", "__conda_activate", "__conda_exe", "__conda_hashr", "__conda_reactivate",
        "_CE_CONDA", "_CONDA_EXE", "_CONDA_ROOT", "conda", "CONDA_EXE", "CONDA_PYTHON_EXE", "CONDA_SHLVL", "mamba",
        "CONDA_PREFIX", "CONDA_PROMPT_MODIFIER", "CONDA_DEFAULT_ENV",
        "CONDA_PREFIX_1","CONDA_PREFIX_2"}
for i, var in pairs(vars) do
    if (myShellType() == "sh") then
        execute {
            cmd = "unset " .. var,
            modeA = {"unload"}
        }
    end
    if (myShellType() == "csh") then
        execute {
            cmd = "unsetenv " .. var,
            modeA = {"unload"}
        }
    end
end
if (myShellType() == "csh") then
    execute {
        cmd = "unalias conda",
        modeA = {"unload"}
    }
end

family("python")


