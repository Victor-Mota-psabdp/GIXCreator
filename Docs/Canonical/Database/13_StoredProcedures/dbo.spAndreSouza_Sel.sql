SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spAndreSouza_Sel]--'2015-05-01','2015-05-31'
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
		
		[Net Revenue CHB]		float,
		[Net Revenue Transp]	float		
	)
	

Declare @Grupo Varchar(50)
If @Grupo is NULL
begin
	set @Grupo = ''
end

insert into @TempNF

	select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_proc_him	[JOB],
		LLP.ETA_LIM			[ETA],
		LLP.ATA_LIM			[ATA],		 
		'IM'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
			
		sum(RFI.Valor_Total) [Custos Total],					
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Imp_Mar CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIM and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIM
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIM and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIM
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_imp_mar hou with(nolock) on hou.num_proc_him=CTA.Num_Proc_HIM
		Join LLP_imp_mar LLP with(nolock)  on hou.num_proc_him=LLP.num_proc_lim
		join Localidade LOC	with(nolock)  on hou.Cd_Dst_HIM=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HIM is not null		
		and convert(datetime,HOU.Dt_Emis_HIM,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc_him,
			LLP.ETA_LIM	,LLP.ATA_LIM,LOC.Nome_Local,
			TT.Tipo_Prod_Code
UNION ALL
--IMP AER
	select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_Proc_HIA	[JOB],
		LLP.ETA_LIA			[ETA],
		LLP.ATA_LIA			[ATA],		 
		'IA'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
		
		sum(RFI.Valor_Total) [Custos Total],						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Imp_Aer CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_Imp_Aer hou with(nolock) on hou.Num_Proc_HIA=CTA.Num_Proc_HIA
		Join LLP_Imp_Aer LLP with(nolock)  on hou.num_proc_hia=LLP.Num_Proc_Lia
		join Localidade LOC	with(nolock)  on hou.Cd_Dst_HIA=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.cd_consig_hia=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on Cd_Consig_HIA=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HIA is not null		
		and convert(datetime,HOU.Dt_Emis_HIA,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc_hia,
			LLP.ETA_LIA	,LLP.ATA_LIA,LOC.Nome_Local,
			TT.Tipo_Prod_Code
			
UNION ALL

	select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_Proc_HIO	[JOB],
		LLP.ETA_Lio	[ETA],
		LLP.ATA_LIO		[ATA],		 
		'IO'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
		
		
		sum(RFI.Valor_Total) [Custos Total],						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Imp_Out CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIO and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIO
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIO and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIO
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=CTA.Num_Proc_HIO
		Join LLP_Imp_Out LLP with(nolock)  on hou.num_proc_hio=LLP.Num_Proc_Lio
		join Localidade LOC	with(nolock)  on hou.Cd_Dst_HIO=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.Cd_Consig_HIO=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on Cd_Consig_HIO=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HIO is not null		
		and convert(datetime,HOU.Dt_Emis_HIo,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc_hio,
			LLP.ETA_Lio,LLP.ATA_Lio,LOC.Nome_Local,
			TT.Tipo_Prod_Code
		
UNION ALL
--Exportacao Maritima
		select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_Proc_HEM	[JOB],
		LLP.ETA_Lem			[ETA],
		LLP.ATA_Lem			[ATA],		 
		'EM'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
		
		
		sum(RFI.Valor_Total) [Custos Total],						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Exp_Mar CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HEM and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HEM
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HEM and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HEM
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_Exp_Mar hou with(nolock) on hou.Num_Proc_HEM=CTA.Num_Proc_HEM
		Join LLP_Exp_Mar LLP with(nolock)  on hou.Num_Proc_HEM=LLP.Num_Proc_Lem
		join Localidade LOC	with(nolock)  on hou.Cd_Org_HEM  = LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.Cd_Export_HEM=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on Cd_Export_HEM=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HEM is not null		
		and convert(datetime,HOU.Dt_Emis_HEM,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_Proc_HEM,
			LLP.ETA_Lem	,LLP.ATA_Lem,LOC.Nome_Local,
			TT.Tipo_Prod_Code
UNION ALL
--Exportação Aerea
	select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_Proc_HEA	[JOB],
		LLP.ETA_Lea			[ETA],
		LLP.ATA_Lea			[ATA],		 
		'EA'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
		
		sum(RFI.Valor_Total) [Custos Total],						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Exp_Aer CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HEA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HEA
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HEA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HEA
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_Exp_Aer hou with(nolock) on hou.Num_Proc_HEA=CTA.Num_Proc_HEA
		Join LLP_Exp_Aer LLP with(nolock)  on hou.num_proc_hea=LLP.Num_Proc_Lea
		join Localidade LOC	with(nolock)  on hou.Cd_Org_HEA=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.Cd_Export_HEA=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on HOU.Cd_Export_HEA=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HEA is not null		
		and convert(datetime,HOU.Dt_Emis_HEA,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_proc_hea,
			LLP.ETA_Lea	,LLP.ATA_Lea,LOC.Nome_Local,
			TT.Tipo_Prod_Code
			
UNION ALL
--Exportaçao Outros
	select 
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)	[Grupo],		 
		CLI.Apelido			[Empresa],
		HOU.Num_Proc_HEO	[JOB],
		LLP.ETA_LEo	[ETA],
		LLP.ATA_Leo		[ATA],		 
		'EO'				[Modal],
		LOC.Nome_Local		[Porto],
		
		sum(FAD.Valor_ARP)	[Gross Revenue Total], --Total NF do JOB
		(case when TT.Tipo_Prod_Code = 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue CHB],--Soma dos itens da NF q tem Tipo Taxa CHB
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(FAD.Valor_ARP)		
		end) [Gross Revenue Transp], --ambos e não chb
		
		sum(RFI.Valor_Total) [Custos Total],						
		(case when TT.Tipo_Prod_Code = 1 then
			sum(RFI.Valor_Total)		
		end) [Custos CHB],  --doc register/registro financeiro  -chb
		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
			sum(RFI.Valor_Total)		
		end) [Custos Transp], --doc register/registro financeiro  -ambos e não chb
		
		NULL[Net Revenue CHB], --F - Coluna H
		NULL [Net Revenue Transp] --G - Coluna I	
	
	from 
		Cta_Cte_Hou_Exp_Out CTA	
		left join Fatura_Arg_Det FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HEO and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HEO
		left Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
		left join Registro_Financeiro_Item RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HEO and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HEO
		left Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
		Join House_Exp_Out hou with(nolock) on hou.Num_Proc_HEO=CTA.Num_Proc_HEO
		Join LLP_Exp_Out LLP with(nolock)  on hou.num_proc_heo=LLP.Num_Proc_Leo
		join Localidade LOC	with(nolock)  on hou.Cd_Org_HEO=LOC.Cd_Local
		Join Pessoa CLI with(nolock)  on HOU.Cd_Export_HEO=CLI.cd_pes
		left Join Pessoa_LLP PLLP with(nolock)  on HOU.Cd_Export_HEO=PLLP.cd_pes
		left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		--Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
		--join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site	
	Where
		--CTA.Num_Proc_HIA = 'IMATL201502082BR' and 
		cta.Num_NF_HEO is not null		
		and convert(datetime,HOU.Dt_Emis_HEO,103) between @Data_Inicial and @Data_Final
	Group by 
			CLI.Apelido,PP.Apelido,	HOU.Num_Proc_HEO,
			LLP.ETA_Leo,LLP.ATA_Leo,LOC.Nome_Local,
			TT.Tipo_Prod_Code
		
		
select Grupo,Empresa,JOB,ETA,ATA,Modal,Porto,
	SUM([Gross_Revenue_Total])					[Gross_Revenue_Total], 
	SUM([Gross Revenue Transp])					[Gross Revenue Transp],	
	SUM([Gross_Revenue_CHB])					[Gross_Revenue_CHB],
	sum([Custos Total])							[Custos Total], 
	SUM([Custos CHB])							[Custos CHB],
	sum([Custos Transp])						[Custos Transp],
	SUM([Gross_Revenue_CHB]) - SUM([Custos CHB]) [Net Revenue CHB],
	SUM([Gross Revenue Transp]) - SUM([Custos Transp]) [Net Revenue Transp] 
from @TempNF
group by 
Grupo,Empresa,JOB,ETA,ATA,Modal,Porto
order by ETA,Modal
GO
