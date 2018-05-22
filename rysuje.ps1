
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
# create chart object
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width = 500
$Chart.Height = 400
$Chart.Left = 50
$Chart.Top = 50

$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$Chart.ChartAreas.Add($ChartArea)

# add data to chart
$disks = get-wmiobject -class "Win32_LogicalDisk" -computerName "." | ?{$_.drivetype -eq 3}
$Diski = $disks | select @{name="Id"; expression={$_.deviceid}}, @{ "name"="Percent"; expression={"{0:n2}" -f (1-$_.freespace/$_.size)}}
$Dpercent = [int]$Diski.Percent
$Pvalue = (Get-Counter -counter "\procesor(_total)\czas procesora (%)").CounterSamples.CookedValue
$Mpercent=(Get-Counter "\pamięć\zadeklarowane bajty w użyciu (%)").CounterSamples.CookedValue

$zamiary = @{ $Diski.id = $Dpercent ; "Processor" = $Pvalue; "Memory" = $Mpercent } 


[void]$Chart.Series.Add("Data")
$Chart.Series["Data"].Points.DataBindXY($Zamiary.Keys, $Zamiary.Values) 
$max = $Chart.Series["Data"].Points.FindMaxbyValue()
$max.Color = [System.Drawing.Color]::Red

# nazwy x y
$ChartArea.AxisX.Title = "Objekty"
$ChartArea.AxisY.Title = "Wartości"

$Chart.BackColor = [System.Drawing.Color]::Transparent

# display the chart on a form
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$Form = New-Object Windows.Forms.Form
$Form.Text = "Wykres"
$Form.Width = 600
$Form.Height = 700
$Form.controls.add($Chart)
$Form.Add_Shown({$Form.Activate()})
$Form.ShowDialog()
