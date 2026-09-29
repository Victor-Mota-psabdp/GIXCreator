SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spATL_JMD_Master_rel

@grupo varchar(50)

as

--Declare @Num_Proc varchar(16)
declare @sqlBody nvarchar(500)
DECLARE @ActualNumberOfResults int;
Declare @TempJOB table
(
JOB varchar(16),
strIntruction varchar(1)
)
Declare @TempErro table
(
JOB varchar(16),
qty int
)

insert @TempJOB
EXEC sp_executesql N'spIntAXJMD_Sel';

declare @JOB varchar(16)
declare @strIntruction varchar(1)

Declare cTemp cursor for
select JOB,strIntruction from @TempJOB
Open cTemp
Fetch next From cTemp into @JOB,@strIntruction
While @@FETCH_STATUS=0
Begin
set @sqlBody ='spATL_AXMasterJob_Sel ' + ''''+ @JOB + ''''
--print @sqlBody
--Select COUNT(*) EXEC sp_executesql  @sqlBody;
EXEC sp_executesql  @sqlBody 
SET @ActualNumberOfResults = @@ROWCOUNT;
--EXEC ('Select @ActualNumberOfResults = count(*) '+  @sqlBody + '; insert into @TempErro (JOB,qty) Values (@JOB,@ActualNumberOfResults);');
--SET @ActualNumberOfResults = @@ROWCOUNT;
insert @TempErro
select @JOB,@ActualNumberOfResults
Fetch next From cTemp into @JOB,@strIntruction
End
close CTemp
deallocate CTemp

select JOB from @TempErro
where qty =0 
GO
