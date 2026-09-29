SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido dia 13/03/2012 - chamado: 19074 a taxa: Perda-Prejuizo - PRJ
--[spATL_Divergencia_Operacional_V2]'GRUPO RHODIA','2016-06-01', '2016-10-30'
--incluida a view do vwclienteHouse, pra deixar o report igual do spATL_Divergencia_Operacional - 2/9/2015- CADU
CREATE PROCEDURE  [dbo].[spATL_Divergencia_Operacional_V2]
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
				
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

		
Select	
	P.Apelido							[Cliente],
	PG.Apelido							[Grupo],
	CTA.Num_Proc_HIA					[BDP Ref.],
	Nome_Tp_Tx							[Nome da Taxa],
	CTA.Vlr_Org_HIA				[Valor],
	convert(Datetime,CTA.Dt_Ins_HIA,105) 	[Data de Registro],	
	substring(CTA.Dt_Ins_HIA,4,2)			[Mês]
From
	vwcta_cte CTA with(nolock)
	--caixa_hou_imp_mar CXA	
	--Join cta_cte_hou_imp_mar CTA on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_Tx and cta.dc_him=cxa.dc_him
	Join Tipo_Taxa TT	with(nolock) on TT.cd_tp_Tx = CTA.Cd_Tp_Tx
	--left Join vwCXAS CXA		with(nolock) on CTA.Num_Proc_HIA = CXA.Num_Proc_HIA and cta.cd_tp_tx=cxa.cd_tp_Tx and CTA.DC_HIA = CXA.DC_HIA
	--join vwCliente vw	with(nolock) on CXA.Num_Proc_HIA = vw.num_proc
	join vwCliente_House vw	with(nolock) on CTA.Num_Proc_HIA = vw.num_proc
	Join Pessoa_LLP PLL with(nolock) on PLL.Cd_Pes=vw.cd_cliente --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
	join Grupo G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	join Pessoa P		with(nolock) on PLL.Cd_Pes = P.Cd_Pes 
Where
	--num_proc = 'EMRHO201606068BR' and
	--convert(Datetime,Dt_Pgto_Rcto_HIA,105)  between @DTinicial and @DTfinal and
	convert(Datetime,CTA.Dt_Ins_HIA,105)  between @DTinicial and @DTfinal and
	(PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL') and
	len(CTA.num_proc_hia) = '16' and
	CTA.cd_tp_tx in ('XMI','XMH','XYT','XYY','XYU','XYV','XYX','XYZ','PRJ','FDG','200','201','202','203')
	 
	 Order BY Grupo
GO
