SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spATLAXTtmp_Upd(
		@CD_PEs varchar(30),
		@Cd_AX int)
as
--set @Cd_Pes='P000013195'
--Set @CD_aX=947

if not exists(
select * from pessoa_atl_Ax
where  tipo='F'  and cd_pes=@cd_pes
)

BEgin

insert pessoa_atl_Ax values(@CD_PEs,@Cd_AX,'','','F')
--where  tipo='F'  and cd_pes in ('P000010803','P18814')

End

Else
Begin
	PRint 'Ja existe'
End
GO
