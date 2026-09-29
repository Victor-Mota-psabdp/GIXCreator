SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Osney_Rel]--'2013-01-01','2013-01-31'
(	
	@Dt_Inicial	datetime,
	@Dt_Final	datetime
)
AS

Declare @Fatura Table
		(
			Fatcod		varchar(17),
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Fatura		
			Select i.fatcod,(case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc from item_fat I				
				Join Fatura F on F.fatcod=i.fatcod 
			where
				fatdtEmissao >='01-01-2013' and fatstatus =1
	End	

	
Select 
	CTA.num_proc_hia						[JOB],
	convert(datetime,dt_ins_hia,103)		[Data],
	TT.nome_tp_tx							[Taxa],
	nome_Raz_soc							[Cliente],
	CTA.vlr_org_hia							[Valor Original],
	Nome_tp_moeda							[Moeda Original],
	(case when Num_NF_HIA is null then
		[dbo].[VerParidade](CTA.dt_prev_pgto_hia,CTA.cd_tp_moeda,'OFC')
	else
		par_NF_HIA end)						[Paridade],
	convert(datetime,CTA.dt_prev_pgto_hia,105)	[Data de Registro],
	(case when Num_NF_HIA is null then
		CTA.vlr_org_hia	* [dbo].[VerParidade](CTA.dt_prev_pgto_hia,CTA.cd_tp_moeda,'OFC')
	else
		Vlr_Pgto_Nf_Hia end)				[BRL Value],
	Num_NF_Hia								[Nota Fiscal],
	Ref_Acesso_NF_HIa						[Tipo],
	Fat.FatCOD								[Fatura],
	CXA.Num_Lcto							[LA]
	
from vwcta_Cte CTA
	left join vwcxas CXA on CTA.num_proc_hia = CXA.num_proc_hia and CTA.DC_Hia= CXA.DC_Hia and CTA.cd_tp_tx = CXA.cd_tp_tx
	join Tipo_Taxa TT on CTA.cd_tp_tx = TT.cd_tp_tx 
	join Tipo_Moeda TM on TM.cd_tp_moeda = CTA.cd_tp_moeda
	Join Pessoa PP on pp.cd_pes=cd_cred_dev_hia
	Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hia and FAt.cd_tp_tx=cta.cd_tp_Tx and fat.dc=cta.dc_hia
where
--	CTA.num_proc_hia = 'IAATL201301049BR'
	convert(datetime,dt_ins_hia,103) between @Dt_Inicial and @Dt_Final
	and CTA.dc_hia = 'C'
	and isnull(CTA.Ref_Acesso_NF_HIA,'A') <> 'P'
	and CTA.vlr_org_hia <> 0
order by 1







GO
