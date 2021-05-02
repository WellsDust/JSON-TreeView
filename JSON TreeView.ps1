[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$WebC = New-Object System.Net.WebClient
$WebC.Headers.Add("Authorization", "Bearer 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")
$WebC.Headers.Add("User-Agent","Unity web player")
$global:dlchk = New-Object System.Windows.Forms.Timer
$global:dlchk.Interval = 100
$global:dlchk.Add_Tick({Receive-Job $djob})

$djob = Register-ObjectEvent -InputObject $WebC -EventName DownloadStringCompleted -Action{
    $global:dlchk.Stop()
    $JSON = ConvertFrom-Json $EventArgs.Result

    
    $RowCount = -1
    $ColumnCount = -1
    foreach($root in $JSON.SyncRoot){
        $RowCount++
        $ColumnCount=-1
        #$SyncNode = $global:APITree.Nodes.Add("SyncRoot[$RowCount]","SyncRoot[$RowCount]")
        BuildTreeView -JList $JSON.SyncRoot[$RowCount] -pnode $global:APITree.Nodes
        if($RowCount -gt 0){
            $global:TableView.Rows.Add()
        }
        foreach($item in $global:TableView.Columns){
            $ColumnCount++
            $value = $item.HeaderText
            $exp = '$global:TableView['+$ColumnCount+',0].Value = $JSON.SyncRoot['+ $ColumnCount +',' + $RowCount +'].' + $value
            #Write-Host $exp
            Invoke-Expression $exp

        }
    }

}

function global:BuildTreeView{
    param(
        [pscustomobject]$JList,
        [System.Windows.Forms.TreeNodeCollection]$pnode,
        [string] $ppath
    )
    foreach($prop in $JList.psobject.properties.name){
        if($prop -ne "Length"){
            if($ppath.Length -ne ""){
                $parents = $ppath + "." + $prop
            }else{
                $parents = $prop
            }
            $unique = $true
            foreach($item in $pnode){
                if($item.Text -eq $prop){
                    $unique = $false
                    break
                }
            }
            if($unique){
                $cnode =$pnode.Add($parents)
                $cnode.Checked = $true
            
                $global:TableView.Columns.Add($parents,$parents)
                foreach($item in $JList.$prop){
                    BuildTreeView -JList $item -pnode $cnode.Nodes -ppath $parents
                }
            }
        }
    }
}
function UncheckNodes{
    param($nodes)
    foreach($item in $nodes){
        $item.Checked = $false
        UncheckNodes $item.Nodes
        foreach($col in $TableView.Columns){
            if($col.HeaderText -eq $item.Text){
                $col.Visible=$item.Checked
                break
            }
        }
    }
}
function Node_Changed(){
    if($_.Node.Checked -eq $false){UncheckNodes $_.Node.Nodes}
    foreach($item in $TableView.Columns){
        if($item.HeaderText -eq $_.Node.Text){
            $item.Visible=$_.Node.Checked
            break
          }
    }
}

function Submit{
    Write-Host "Start download"
    $WebC.DownloadStringAsync($APIURL.Text)
    $dlchk.Start()
}

function MainForm_Shown{
    [System.Windows.Forms.TreeView]$global:APITree = $APITree
    [System.Windows.Forms.DataGridView]$global:TableView = $TableView
    $APITree.Add_NodeMouseClick({Node_Changed})
    $APIURL.Text = "https://api.github.com/repos/WellsDust/JSON-TreeView/issues"
    $Submit.Add_Click({Submit})
}

./GUI.PS1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               