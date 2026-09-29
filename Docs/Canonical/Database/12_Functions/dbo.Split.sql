SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[Split]
(
@RowData nvarchar(MAX),
@SplitOn nvarchar(MAX)
)  
RETURNS @RtnValue table 
(
Data nvarchar(MAX)
) 
AS  
BEGIN 
Declare @Cnt int
Set @Cnt = 1

While (Charindex(@SplitOn,@RowData)>0)
Begin
    Insert Into @RtnValue (data)
    Select 
        Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))

    Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
    Set @Cnt = @Cnt + 1
End

Insert Into @RtnValue (data)
Select Data = ltrim(rtrim(@RowData))

Return
END
GO
