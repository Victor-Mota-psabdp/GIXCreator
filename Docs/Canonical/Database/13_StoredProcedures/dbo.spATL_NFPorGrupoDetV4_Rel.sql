SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Utilizei pra retirar um report detalhado pra raquel- cadu 29/6/2016
Create Procedure [dbo].[spATL_NFPorGrupoDetV4_Rel]--'GRUPO SYNGENTA'
	@Grupo varchar(50)
AS

if @Grupo = '' 
begin
	Set @Grupo = 'ALL'
End

select 
	'IM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' 
			then 'Grupo DOW AGRO' else 'Grupo Dow' end) 
		else PP.Apelido end)  Grupo,
	HOU.Num_proc_him [JOB],
	--sum(dbo.valor(Valor_ARP,DC)) 
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @Grupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_him,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 



Union All


select 
	'IA' Modal ,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
	HOU.Num_proc_hia [JOB],
	--sum(dbo.valor(Valor_ARP,DC)) Valor,
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hia=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @GRupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hia,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

Union All

select 
	'IO' Modal ,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
	HOU.Num_proc_hio JOB,
	--sum(dbo.valor(Valor_ARP,DC)) Valor,
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 	
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @GRupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hio,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)


Union All


select 
	'EO' Modal ,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
	Hou.Num_proc_heo JOB,
	--sum(dbo.valor(Valor_ARP,DC)) Valor,
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @GRupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_heo,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

Union All


select 
	'EM' Modal ,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
	Hou.Num_proc_hem JOB,
	--sum(dbo.valor(Valor_ARP,DC)) Valor,
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_exp_MAR hou with(nolock)  on hou.num_proc_hem=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @GRupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_hem,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 


Union All

select distinct
	'EA' Modal ,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)   Grupo,
	HOU.Num_proc_hea JOBs,
	--sum(dbo.valor(Valor_ARP,DC)) Valor,
	Valor_ARP Valor,
	DC, 
	TT.Nome_tp_tx, 
	CLI.Apelido Cliente,
	month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
from vwFaturasValidasArg CTA with(nolock)
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	--year(Dt_Fatura)=2014
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	--and PP.Apelido = @Grupo
	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hea,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

GO
