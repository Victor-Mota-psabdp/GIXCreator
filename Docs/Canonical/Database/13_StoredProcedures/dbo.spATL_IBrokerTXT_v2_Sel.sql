SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_IBrokerTXT_v2_Sel 'IAGVD201505035BR'
CREATE procedure [dbo].[spATL_IBrokerTXT_v2_Sel](
@ID_ITDI bigint
)--spATL_IBrokerTXT_Sel 1
as

--Declare @ID_ITDI bigint
--Declare @ID_View bigint
--select * from IBROKER_ITDI
--set @ID_View =(Select ID from IBROKER_CAPI_V2 where JOB = @Processo and status =1)
--set @ID_ITDI = (select ID_ITDI from dbo.IBROKER_ITDI where ID_View = @ID_View)

Declare @TableTemp Table(
	Temp varchar(500)
)
insert @TableTemp
select [01]+[02]+[03]+[04]+[05]+[06]+[07] from IBROKER_ITDI where ID_ITDI = @ID_ITDI
insert @TableTemp
select [01]+[02]+[03]+[04]+[05]+[06]+[07]+[08]+[09]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]+[20]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35]+[36]+[37]+[38]+[39]+[40]+[41]+[42]+[43]+[44] from IBROKER_CAP1 where ID_ITDI = @ID_ITDI
insert @TableTemp
select [01]+[02]+[03]+[04]+[05]+[06]+[07]+[08]+[09]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]+[20]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35] from IBROKER_CAP2 where ID_ITDI = @ID_ITDI
declare @x int
set @x = 0
set @x = (select  max(ID_ITEA) from IBROKER_ITEA where ID_ITDI = @ID_ITDI)

declare @y int
set @y = 1

WHILE @x >=@y
begin

	insert @TableTemp
		select  [01]+[02]+[03]+[04]+[05]+[06]+[07]+[08]+[09]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]+[20]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35]Linha from IBROKER_ITEA where ID_ITDI = @ID_ITDI and ID_ITEA = @y
		union all
		select	[01]+[02]+[03]+[04]+[05]+[06]+[07]+[08]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[21]+[22]+[23]+[24]+[25]+[26]+[27]+[28]+[29]+[30]+[31]+[32]+[33]+[34]+[35]+[36]+[37]+[38]+[39]+[40]+[41]+[42]+[43]+[44]+[45]+[46]+[47]+[48]Linha from IBROKER_ITEB where ID_ITDI = @ID_ITDI and ID_ITEA = @y
		union all

		select [01]+[02]+[03]+[04]+[05] Linha from dbo.IBROKER_DPnn where ID_ITDI = @ID_ITDI and ID_ITEA = @y
		set @y = @y+1
end
insert @TableTemp
select [01]+[02]+[03]+[04]+[05]+[06]+[07]+[08]+[09] from IBROKER_AG4A where ID_ITDI = @ID_ITDI

insert @TableTemp
select [01]+[02]+[03] from IBROKER_FTDI where ID_ITDI = @ID_ITDI

select * from @TableTemp

                                                                                                                                                 



GO
