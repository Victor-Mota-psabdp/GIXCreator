SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRevenueReportV2_Rel]--'2015-07-06','2015-07-06'
(
	@Data_Inicial as Datetime,
	@Data_Final as Datetime
)
AS
SET NOCOUNT ON

Declare @TempNF Table
	(
		Grupo		varchar(50),		 
		Empresa		varchar(50),
		JOB			varchar(16),
		ETA			Datetime,	
		ATA			Datetime,		 
		Modal		varchar(2),
		Porto		varchar(30),		
		[Gross_Revenue_Total]	float,
		[Gross_Revenue_CHB]		float,
		[Gross Revenue Transp]	float,
		[Custos Total]			float,	
		[Custos CHB]			float,
		[Custos Transp]		float,
		[PassTru Total]			float,	
		[PassTru CHB]			float,
		[PassTru Transp]		float,
		
		[Net Revenue CHB]		float,
		[Net Revenue Transp]	float		
	)
	
insert into @TempNF
--NF
	select
		PP.Apelido			[Grupo],			 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total], --Total NF do JOB
			
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end)	[Gross Revenue Transp], --ambos e não chb
			
		NULL [Custos Total],	
						
		NULL [Custos CHB],  --doc register/registro financeiro  -chb

		NULL [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		NULL [PassThru Total],
		NULL [PassThru CHB],
		NULL [PassThru Transp],
		NULL [Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I
	from vwFaturasValidasArg FAD			
		join vwcta_Cte CTA	 with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA		
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on FAD.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		convert(datetime,FAD.Dt_Fatura,103) between @Data_Inicial and @Data_Final			
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local,
			TT.Tipo_Prod_Code
	
UNION ALL
--Doc Register		
select
		PP.Apelido			[Grupo],			 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		NULL [Gross Revenue Total], --Total NF do JOB
			
		NULL  [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		NULL [Gross Revenue Transp], --ambos e não chb
			
		sum(dbo.valor(RFI.Valor_Total,RFI.DC))[Custos Total],	
						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end)[Custos CHB],  --doc register/registro financeiro  -chb

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		NULL [PassThru Total],
		NULL [PassThru CHB],
		NULL [PassThru Transp],
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	

	from vwRegistroFinanceiroItem RFI
		join vwcta_Cte CTA  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on RFI.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where		
		convert(datetime,RFI.Invoice_Dt,103) between @Data_Inicial and @Data_Final			
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local,
			TT.Tipo_Prod_Code
		
UNION ALL
--MAster NF
	select	
		PP.Apelido			[Grupo],			 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total], --Total NF do JOB
			
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end)	[Gross Revenue Transp], --ambos e não chb
			
		NULL [Custos Total],	
						
		NULL[Custos CHB],  --doc register/registro financeiro  -chb

		NULL [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		NULL [PassThru Total],
		NULL [PassThru CHB],
		NULL [PassThru Transp],
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	

	from vwFaturasValidasArg FAD
		join vwcta_Cte CTA with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA		
		Join vwClienteALLJOBS HOU on HOU.Master=cta.Num_Proc_HIA 
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on FAD.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		convert(datetime,FAD.Dt_Fatura,103) between @Data_Inicial and @Data_Final			
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local,
			TT.Tipo_Prod_Code
			
UNION ALL
--Doc Register
	select	
		PP.Apelido			[Grupo],			 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		NULL [Gross Revenue Total], --Total NF do JOB
			
		NULL [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		NULL [Gross Revenue Transp], --ambos e não chb
			
		sum(dbo.valor(RFI.Valor_Total,RFI.DC))[Custos Total],	
						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end)[Custos CHB],  --doc register/registro financeiro  -chb

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		NULL [PassThru Total],
		NULL [PassThru CHB],
		NULL [PassThru Transp],
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I
	from vwRegistroFinanceiroItem RFI 
		join  vwcta_Cte CTA with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		Join vwClienteALLJOBS HOU on HOU.Master=cta.Num_Proc_HIA
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on RFI.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where	
		--HOU.num_proc = 'EAATL201507003BR'
		convert(datetime,RFI.Invoice_Dt,103) between @Data_Inicial and @Data_Final			
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local,
			TT.Tipo_Prod_Code

--CTA CTE
UNION ALL

	select	
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total], --Total NF do JOB
			
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end)	[Gross Revenue Transp], --ambos e não chb
			
		sum(dbo.valor(RFI.Valor_Total,RFI.DC))[Custos Total],	
						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end)[Custos CHB],  --doc register/registro financeiro  -chb

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC') * CTA.Vlr_Org_HIA,CTA.DC_HIA)) 
			[PassThru Total],	
							
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
		end) [PassThru CHB], 
		 
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
		end) [PassThru Transp],
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I
	from vwcta_Cte CTA	
		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA
		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA				
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		--CTA.Num_Proc_HIA = 'EAATL201507003BR' 
		convert(datetime,cta.Dt_Ins_HIA,103) between @Data_Inicial and @Data_Final	
		and FAD.Num_Proc is null
		and RFI.Num_Proc is null
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc,
			ETA,ATA,LOC.Nome_Local,
			TT.Tipo_Prod_Code
	
UNION ALL
--MAster CTA CTE
	select	
		PP.Apelido			[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc		[JOB],
		HOU.ETA				[ETA],
		HOU.ATA				[ATA],		 
		left(HOU.Num_proc,2)[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[Gross Revenue Total], --Total NF do JOB
			
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(FAD.Valor_ARP,FAD.DC))		
		end)	[Gross Revenue Transp], --ambos e não chb
			
		sum(dbo.valor(RFI.Valor_Total,RFI.DC))[Custos Total],	
						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end)[Custos CHB],  --doc register/registro financeiro  -chb

		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		 
		sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC') * CTA.Vlr_Org_HIA,CTA.DC_HIA)) 
			[PassThru Total],	
							
		(case when TT.Tipo_Prod_Code = 1 then
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
		end) [PassThru CHB], 
		 
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(dbo.valor(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),cta.cd_tp_moeda,'OFC')* CTA.Vlr_Org_HIA,Cta.DC_HIA)) 		
		end) [PassThru Transp],
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	

	from 
		vwcta_Cte CTA with(nolock)
		Join vwClienteALLJOBS HOU with(nolock) on hou.Master=CTA.Num_Proc_HIA	
		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA		
		join Localidade LOC	with(nolock)  on hou.cd_local=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		--CTA.Num_Proc_HIA = 'EAATL201507003BR' 
		convert(datetime,CTA.Dt_Ins_HIA,103) between @Data_Inicial and @Data_Final	
		and FAD.Num_Proc is null
		and RFI.Num_Proc is null
	Group by 
		CLI.Apelido,PP.Apelido,	HOU.Num_proc,
		ETA,ATA,LOC.Nome_Local,
		TT.Tipo_Prod_Code
		
select Grupo,Empresa,JOB,ETA,ATA,Modal,Porto,
	SUM([Gross_Revenue_Total])					[Gross_Revenue_Total], 	
	SUM([Gross_Revenue_CHB])					[Gross_Revenue_CHB],
	SUM([Gross Revenue Transp])					[Gross Revenue Transp],	
	sum([Custos Total])							[Custos Total], 
	SUM([Custos CHB])							[Custos CHB],
	sum([Custos Transp])						[Custos Transp],
	sum([PassTru Total])						[Pass Total], 
	SUM([PassTru CHB])							[Pass CHB],
	sum([PassTru Transp])						[Pass Transp],
	SUM(isnull([Gross_Revenue_CHB],0)) + SUM(isnull([Custos CHB],0)) + SUM(isnull([PassTru CHB],0)) [Net Revenue CHB],
	SUM(isnull([Gross Revenue Transp],0)) + SUM(isnull([Custos Transp],0)) + SUM(isnull([PassTru Transp],0)) [Net Revenue Transp] 
from @TempNF 
group by 
Grupo,Empresa,JOB,ETA,ATA,Modal,Porto
order by Modal
GO
