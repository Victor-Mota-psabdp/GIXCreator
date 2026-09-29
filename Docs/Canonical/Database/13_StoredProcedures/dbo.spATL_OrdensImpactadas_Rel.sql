SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure	[dbo].[spATL_OrdensImpactadas_Rel] --'01-01-2008'
(
	@Grupo varchar(20),
	@Dt_Inicial	datetime,
	@Dt_Final	datetime
)
As
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

	Select
		dbo.FStatus_Plasticos(hou.num_proc_him,getdate())		[Divisão],
		Right(Left(P.Planta,5),2)								[Company ID],
		P.Planta,
		P.Num_PO												PU,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)						GMID,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)					Produto,
		sum(isnull(PD.Peso_Liquido_TOT,0))						[Peso Liquido Valor],
		isnull(LLP.ATD_LIM,LLP.ETD_LIM)							[Data Embarque],
		Isnull(LLP.ATA_LIM,LLP.ETA_LIM)							[Data Atracacao],
		Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,getdate()),ETA_Lim +13) [Data Previsao],
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate()) [Motivo Atraso],
		HOU.Num_Proc_HIM										[BDP Reference]
	from
		House_IMP_MAR HOU
		Join LLP_IMP_MAR	LLP	on HOU.Num_Proc_HIM =LLP.Num_Proc_LIM
		Join Pedido_Ship	PS	on HOU.Num_Proc_HIM =PS.Num_Proc
		Join Pedido_Det 	PD	on PD.cd_pedido		=PS.cd_pedido and PD.cd_produto=PS.cd_produto and (PD.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PD.LOTE=PS.LOTE OR PS.LOTE IS NULL)
		Join Pedido			P	on PS.Cd_Pedido		=P.Cd_Pedido
	where
		convert(datetime,Dt_Emis_HIM,105) between @Dt_Inicial and @Dt_Final
		and right(left(LLP.Num_proc_LIM,5),3) = @Grupo
		and dbo.FStatus_Plasticos(hou.num_proc_him,getdate())='ALTERADA'
	group by
		HOU.Num_Proc_HIM,
		HOU.Dt_Emis_HIM,
		P.Num_PO,
		LLP.ATD_LIM,LLP.ETD_LIM,
		LLP.ATA_LIM,LLP.ETA_LIM,
		P.Planta



GO
