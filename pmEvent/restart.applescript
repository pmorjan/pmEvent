--
-- restart.applescript
-- pmEvent
--

(*
set wait to 3
set message to "Restarting in " & wait & "seconds …"

try
	display dialog message buttons {"Cancel", "Restart"} default button 2 cancel button "Cancel" giving up after wait with icon caution
    on error number -128
        return
end try
*)

tell application "System Events" to restart