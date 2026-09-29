SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spDemurrageATL_REL]--'IMBSF201804001BRC'
		@Processo VarChar(17)
AS

SELECT 
	DM.Processo,DM.Fatura,
	(case WHEN DM.cd_pes IS NULL THEN 
		DM.Apelido 
	ELSE P.Nome_raz_soc eND)Apelido,
	
	ORIG.Nome_Local ORIGEM,
	DESTIN.Nome_Local DESTINO,
	HOU.VIAGEM,
	--DM.Apelido,
	DM.Atracacao,DM.Vencimento,DM.Moeda,
	DM.Valor,
	(case when DM.Desconto = 0 then NULL ELSE DM.Desconto END)Desconto,
	DM.Desc_Obs,DM.Navio,DM.HBL,DM.CNPJ,DM.Tipo,DM.Dt_Emis,
	DM.Paridade,isnull(DM.Garantia,0) Garantia ,DM.seq,DM.ID_Status,DM.dt_alter,DM.dt_envio,
	--DD.Processo,DD.Fatura,
	DD.Container,DD.Tipo_Container,DD.Dt_Devolucao,DD.T_Geral,DD.F_Time,
	DD.D_BDP,DD.D_Cobrados,DD.T_Diaria,DD.T_Pagar,DD.T_diaria2,DD.D_1periodo,
	DD.D_2periodo,DD.T_diaria3,DD.D_3periodo
FROM DEMURRAGE_ATL DM with(nolock)
	Join Demurrage_ATL_Det DD with(nolock) on DD.processo=DM.processo and dd.fatura=dm.fatura
	left join pessoa p with(nolock) on p.Cd_Pes = dm.cd_pes
	Left Join vwHouse_Imp	HOU  with(nolock) on HOU.Num_Proc = dM.Processo 
	Left Join Localidade	Orig with(nolock) on HOU.Cd_Org = Orig.Cd_Local 
	Left Join Localidade	Destin with(nolock) on HOU.Cd_Dst = Destin.Cd_Local 
Where
	DM.processo=left(@processo,16) and dm.fatura=right(@processo,1)
	


GO
