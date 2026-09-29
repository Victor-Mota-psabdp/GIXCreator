SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spNFPorGrupoLocalidade_Rel] 
	
AS

Declare @ResultadoFinal Table
		(
			Modal		Varchar(2),
			Grupo		Varchar(50),
			Janeiro		Decimal(10,2) Default 0,
			Fevereiro	Decimal(10,2) Default 0,
			Marco		Decimal(10,2) Default 0,
			Abril		Decimal(10,2) Default 0,
			Maio		Decimal(10,2) Default 0,
			Junho		Decimal(10,2) Default 0,
			Julho		Decimal(10,2) Default 0,
			Agosto		Decimal(10,2) Default 0,
			Setembro	Decimal(10,2) Default 0,
			Outubro		Decimal(10,2) Default 0,
			Novembro	Decimal(10,2) Default 0,
			Dezembro	Decimal(10,2) Default 0,
			Localidade	VArchar(50)
		)

Declare @ResultadoTemp	Table
		(
			Modal	Varchar(2),
			Grupo	Varchar(50),
			Valor	Float,
			Mes		int,
			Localidade Varchar(50)


		)

--spNFPorGrupo_Rel  '01-01-2011','11-30-2011'

Insert @ResultadoTemp

select 
	'IM' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_him
Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()
Group by Apelido,Month(emissao),nome_local


Union All


select 
	'IA' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia

Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()
Group by Apelido,Month(emissao),Nome_Local 

Union All

select 
	'IO' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hio
Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()
Group by Apelido,Month(emissao),nomE_local


Union All


select 
	'EO' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_heo
Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()

Group by 
	Apelido,Month(emissao),Nome_Local


Union All


select 
	'EM' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_exp_MAR hou with(nolock)  on hou.num_proc_hem=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hem

Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()
Group by Apelido,Month(emissao),Nome_Local


Union All

select 
	'EA' Modal ,Apelido Grupo,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) Valor,month(emissao) Mes,Nome_Local Localidade
from 
	vwcta_cte CTA
	Join BAse_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc_hia
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hea

Where
	year(Emissao)=year(getdate()-5)
	and emissao <=getdate()
Group by Apelido,Month(emissao),Nome_Local

insert @resultadofinal(modal,grupo,localidade)

select distinct Modal,grupo,localidade from @ResultadoTemp


Update @ResultadoFinal set Janeiro=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=1 and RF.localidade=RT.localidade


Update @ResultadoFinal set Fevereiro=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=2 and RF.localidade=RT.localidade

Update @ResultadoFinal set Marco=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=3 and RF.localidade=RT.localidade

Update @ResultadoFinal set Abril=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=4 and RF.localidade=RT.localidade

Update @ResultadoFinal set Maio=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=5 and RF.localidade=RT.localidade

Update @ResultadoFinal set Junho=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=6 and RF.localidade=RT.localidade

Update @ResultadoFinal set Julho=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=7 and RF.localidade=RT.localidade

Update @ResultadoFinal set Agosto=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=8 and RF.localidade=RT.localidade

Update @ResultadoFinal set Setembro=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=9 and RF.localidade=RT.localidade

Update @ResultadoFinal set Outubro=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=10 and RF.localidade=RT.localidade

Update @ResultadoFinal set Novembro=isnull(Valor,0) from @ResultadoFinal RF 
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=11 and RF.localidade=RT.localidade

Update @ResultadoFinal set Dezembro=isnull(Valor,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=12 and RF.localidade=RT.localidade


select 
		Modal,Grupo,Janeiro [Janeiro Value],	Fevereiro [Fevereiro Value],Marco [Marco Value], 
		Abril [Abril Value],Maio [Maio Value],Junho [Junho Value],Julho [Julho Value],Agosto [Agosto Value],
		Setembro [Setembro Value],Outubro [Outubro Value],Novembro [Novembro Value],Dezembro [Dezembro Value],Localidade
From
		@ResultadoFinal


GO
