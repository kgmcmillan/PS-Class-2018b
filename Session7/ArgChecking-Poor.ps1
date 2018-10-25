#===============================================================================
#  ArgChecking-Poor.ps1  -  Example of a poor way to structure argument checks
#
#   Try to keep your IF statements and their effects close together to make your
#   script more readable.   The statements below do NOT do this and as a result
#   the script is harder to understand.
#
#===============================================================================

# Check that we have the correct number of script arguments:
# ---------------------------------------------------------
    if ( $Args.Count -eq 2 )
    {
        
    # Check that the first argument is the name of a real folder:
    # ----------------------------------------------------------
        $PurgeFolderName = $Args[0]
        if ( test-path $PurgeFolderName -pathtype container )
        {
        
        # Check that the second argument is a valid number:
        # ------------------------------------------------
            $MaxAge = $Args[1] -as [int]
            if ( MaxAge -ne $null )
            {
            
            # Purge all files in the given folder that are older than the maximum age:
            # -----------------------------------------------------------------------
                Get-ChildItem $PurgeFolderName |
                    where { $_.LastWriteTime -lt (Get-Date).AddDays( -$MaxAge ) |
                    remove-item -whatif
            }
            else
            {
                write-host "`"$($Args[1])`" must be a numeric file age in days"
                exit 1
            }
        
        }
        else
        {
            write-host "Folder `"$PurgeFolderName`" was not found!"
            exit 1
        }
    }
    else
    {
        write-host "Missing required arguments!"
        write-host "This script requires two command line arguments:"
        write-host "   - the folder to be purged"
        write-host "   - the maximum age in days for files to be retained"
        exit 1
    }