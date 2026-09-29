SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_NFPorGrupoV2old_Rel] --'BDP'
	@Grupo varchar(50)
	
AS

Declare @ResultadoFinal Table
		(
			Modal		Varchar(2),
			Grupo		Varchar(50),
			Janeiro		Decimal(10,2) Default 0,
			JaneiroJOB int Default 0,
			Fevereiro	Decimal(10,2) Default 0,
			FevereiroJOB int Default 0,
			Marco		Decimal(10,2) Default 0,
			MarcoJOB int Default 0,
			Abril		Decimal(10,2) Default 0,
			AbrilJOB int Default 0,
			Maio		Decimal(10,2) Default 0,
			MaioJOB int Default 0,
			Junho		Decimal(10,2) Default 0,
			JunhoJOB int Default 0,
			Julho		Decimal(10,2) Default 0,
			JulhoJOB int Default 0,
			Agosto		Decimal(10,2) Default 0,
			AgostoJOB int Default 0,
			Setembro	Decimal(10,2) Default 0,
			SetembroJOB int Default 0,
			Outubro		Decimal(10,2) Default 0,
			OutubroJOB int Default 0, 
			Novembro	Decimal(10,2) Default 0,
			NovembroJOB int Default 0,
			Dezembro	Decimal(10,2) Default 0,
			DezembroJOB int Default 0
		)

Declare @ResultadoTemp	Table
		(
			Modal	Varchar(2),
			Grupo	Varchar(50),
			Valor	Float,
			Jobs int,
			Mes		int


		)

--spNFPorGrupo_Rel  '01-01-2011','10-10-2011'

Insert @ResultadoTemp

select 
	'IM' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_him)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)


Union All


select 
	'IA' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hia)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)

Union All

select 
	'IO' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hio)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)


Union All


select 
	'EO' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct Hou.Num_proc_heo)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)

Union All


select 
	'EM' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct hou.Num_proc_hem)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_MAR hou with(nolock)  on hou.num_proc_hem=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)


Union All

select 
	'EA' Modal ,Apelido Grupo,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hea)JOBs,month(Dt_Fatura) Mes
from 
	Fatura_Arg_Det CTA with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc
	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
Where
	year(Dt_Fatura)=2014
	and Dt_Fatura <=getdate()
	and (Apelido = @Grupo or @Grupo = '') 
	--and month(Dt_Fatura) in ('01','02','03')
Group by Apelido,Month(Dt_Fatura)

insert @resultadofinal(modal,grupo)

select distinct Modal,grupo from @ResultadoTemp


Update @ResultadoFinal set Janeiro=isnull(Valor,0),JaneiroJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=1


Update @ResultadoFinal set Fevereiro=isnull(Valor,0),FevereiroJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=2

Update @ResultadoFinal set Marco=isnull(Valor,0),MarcoJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=3

Update @ResultadoFinal set Abril=isnull(Valor,0),AbrilJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=4

Update @ResultadoFinal set Maio=isnull(Valor,0),MaioJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=5

Update @ResultadoFinal set Junho=isnull(Valor,0),JunhoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=6

Update @ResultadoFinal set Julho=isnull(Valor,0),JulhoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=7

Update @ResultadoFinal set Agosto=isnull(Valor,0),AgostoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=8

Update @ResultadoFinal set Setembro=isnull(Valor,0),SetembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=9

Update @ResultadoFinal set Outubro=isnull(Valor,0),OutubroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=10

Update @ResultadoFinal set Novembro=isnull(Valor,0),NovembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=11

Update @ResultadoFinal set Dezembro=isnull(Valor,0),DezembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=12


select 
		Modal,
		Grupo,
		Janeiro [Janeiro Value],
		JaneiroJob [Janeiro Number],
		Fevereiro [Fevereiro Value],
		FevereiroJOB [Fevereiro Number],
		Marco [Marco Value], 
		MarcoJOB [Marco Number],
		Abril [Abril Value],
		AbrilJOB [Abril Number],
		Maio [Maio Value],
		MaioJOB [Maio Number],
		Junho [Junho Value],
		JunhoJOB [Junho Number],
		Julho [Julho Value],
		JulhoJOB [Julho Number],
		Agosto [Agosto Value],
		AgostoJOB [Agosto Number],
		Setembro [Setembro Value],
		SetembroJOB [Setembro Number],
		Outubro [Outubro Value],
		OutubroJOB [Outubro Number],
		Novembro [Novembro Value],
		NovembroJOB [Novembro Number],
		Dezembro [Dezembro Value],
		DezembroJOB [Dezembro Number]
From
		@ResultadoFinal

GO
