SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRevenueReport_JOB_Rel]--'EAATL21507003BR'
(
	@JOB as Varchar(16)
)
AS
SET NOCOUNT ON

Declare @Grupo Varchar(50)

set @Grupo = ''

Declare @TempNF Table
	(
		Grupo		varchar(50),		 
		Empresa		varchar(50),
		JOB			varchar(16),
		ETA			Datetime,	
		ATA			Datetime,		 
		Modal		varchar(2),
		Porto		varchar(30),
		Nome_Taxa	varchar(50),		
		[Gross_Revenue_Total]	float,
		[Gross_Revenue_CHB]		float,
		[Gross Revenue Transp]	float,
		[Custos Total]			float,	
		[Custos CHB]			float,
		[Custos Transp]			float,
		[PassTru Total]			float,	
		[PassTru CHB]			float,
		[PassTru Transp]		float,		
		[Net Revenue CHB]		float,
		[Net Revenue Transp]	float		
	)
	
insert into @TempNF
--Nota Fiscal
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx, 	
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total],
		
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],
				
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue Transp],
		null,null,null,null,null,null,null,null		
	from 
		vwcta_Cte CTA	
		join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		--Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		--Join LLP_imp_mar LLP with(nolock)  on hou.num_proc=LLP.num_proc_lim
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		CTA.Num_Proc_HIA = @JOB
		--CTA.Num_Proc_HIA = 'IMATL21502082BR' 
	Group by
		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
		CLI.Apelido,PP.Apelido,	HOU.Num_proc,
		HOU.ETA	,HOU.ATA,LOC.Nome_Local
		
UNION ALL
--NF Master
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Master			[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx, 	
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total],
		
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],
				
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue Transp],
		null,null,null,null,null,null,null,null		
	from 
		vwcta_Cte CTA	
		Join vwClienteALLJOBS HOU on HOU.Master=cta.Num_Proc_HIA 
		join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		--Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx		
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		HOU.num_proc = @JOB
		--CTA.Num_Proc_HIA = 'IMATL21502082BR' 
	Group by
		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
		CLI.Apelido,PP.Apelido,	HOU.Master,HOU.Num_proc,
		HOU.ETA	,HOU.ATA,LOC.Nome_Local

UNION ALL
--DOC register	
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx, 
		null,null,null,	
		sum(dbo.valor(RFI.Valor_Total,RFI.DC)) [Custos Total],
		
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos CHB], 
		
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp] 
		,null,null,null,null,null
	from 
		vwcta_Cte CTA	
		join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIa and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		--Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		--Join LLP_imp_mar LLP with(nolock)  on hou.num_proc=LLP.num_proc_lim
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		CTA.Num_Proc_HIA = @JOB 
		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
	Group by
		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			HOU.ETA,HOU.ATA,LOC.Nome_Local

UNION ALL
--Master
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Master			[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx, 
		null,null,null,	
		sum(dbo.valor(RFI.Valor_Total,RFI.DC)) [Custos Total],
		
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos CHB], 
		
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp] 
		,null,null,null,null,null
	from 
		vwcta_Cte CTA
		Join vwClienteALLJOBS hou with(nolock) on hou.Master=CTA.Num_Proc_HIA	
		join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIa and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		--Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		HOU.num_proc = @JOB 
		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
	Group by
		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
			CLI.Apelido,PP.Apelido,	HOU.Master,HOU.Num_proc,
			HOU.ETA,HOU.ATA,LOC.Nome_Local

UNION ALL
--Cta
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx,
		null,null,null,null,null,null,		
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC') * CTA.Vlr_Org_HIA,CTA.DC_HIA)) 
			[PassThru Total],	
							
			(case when TT.Tipo_Prod_Code = 1 then
				sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
			end) [PassThru CHB], 
			 
			(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
				sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIa,Cta.DC_HIa)) 		
			end) [PassThru Transp]
			,null,null
	from 
		vwcta_Cte CTA	
		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		--Join LLP_imp_mar LLP with(nolock)  on hou.num_proc=LLP.num_proc_lim
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		CTA.Num_Proc_HIA = @JOB 
		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
		and FAD.Num_Proc is null
		and RFI.Num_Proc is null
		--and convert(datetime,HOU.Dt_Emis_HIM,103) between @Data_Inicial and @Data_Final			
	Group by 
			TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local
			
UNION ALL
--Master
	select
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Master		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		TT.Nome_Tp_Tx,
		null,null,null,null,null,null,		
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC') * CTA.Vlr_Org_HIA,CTA.DC_HIA)) 
			[PassThru Total],	
							
			(case when TT.Tipo_Prod_Code = 1 then
				sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
			end) [PassThru CHB], 
			 
			(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
				sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIa,Cta.DC_HIa)) 		
			end) [PassThru Transp]
			,null,null
	from 
		vwcta_Cte CTA
		Join vwClienteALLJOBS hou with(nolock) on hou.Master=CTA.Num_Proc_HIA	
		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	Where
		HOU.num_proc = @JOB 
		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
		and FAD.Num_Proc is null
		and RFI.Num_Proc is null
		--and convert(datetime,HOU.Dt_Emis_HIM,103) between @Data_Inicial and @Data_Final			
	Group by 
			TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
			CLI.Apelido,PP.Apelido,	HOU.Master,HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local
			
			
insert into @TempNF
	
select 'Total','','',ETA,ATA,'','','',
	SUM([Gross_Revenue_Total])					[Gross_Revenue_Total], 
	SUM([Gross Revenue Transp])					[Gross Revenue Transp],	
	SUM([Gross_Revenue_CHB])					[Gross_Revenue_CHB],
	sum([Custos Total])							[Custos Total], 
	SUM([Custos CHB])							[Custos CHB],
	sum([Custos Transp])						[Custos Transp],
	sum([PassTru Total])						[Pass Total], 
	SUM([PassTru CHB])							[Pass CHB],
	sum([PassTru Transp])						[Pass Transp],
	SUM(isnull([Gross_Revenue_CHB],0)) + SUM(isnull([Custos CHB],0)) + SUM(isnull([PassTru CHB],0)) [Net Revenue CHB],
	SUM(isnull([Gross Revenue Transp],0)) + SUM(isnull([Custos Transp],0)) + SUM(isnull([PassTru Transp],0)) [Net Revenue Transp] 
from @TempNF  --where JOB = @JOB
--where JOB = 'IMATL21502082BR'
group by  ETA,ATA
--Empresa,JOB,ETA,ATA,Modal,Porto,Nome_Taxa


select * from @TempNF order by Grupo
GO
