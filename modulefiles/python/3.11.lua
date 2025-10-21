depends_on("conda")

local conda_dir = CONDA_PREFIX

if ( myShellType() == "csh" ) then
    local conda_cmd=conda_dir.."/etc/profile.d/conda.csh"
--    execute(cmd="source '"..conda_cmd.."'",modeA={"load"
    execute{cmd="source "..conda_cmd.." activate 3.11",modeA={"load"}}
else
    execute{cmd="conda activate 3.11",modeA={"load"}}
end
