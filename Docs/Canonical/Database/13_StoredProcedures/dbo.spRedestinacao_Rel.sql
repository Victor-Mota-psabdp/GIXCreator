SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRedestinacao_Rel]--''
(	
	@ALL varchar(10)
)

as
select 
	(Case when PP.Apelido ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'GRUPO DOW AGRO' else 'GRUPO DOW' end)
		else PP.Apelido end)		[Grupo],
	CLI.Apelido						[Consignatario],
	HOU.Num_Proc_HIM				[JOB],
	DATEDIFF(day,GETDATE(),LLP.ETA_Lim) [Hoje e ETA],
	HOU.Navio_HIM					[Navio],
	LLP.ETD_Lim						[ETD],
	LLP.ATD_lim						[ATD],
	LLP.ETA_Lim						[ETA],
	LLP.ATA_Lim						[ATA],
	HOU.HAWB_HIM					[HBL],
	HOU.MAWB_HIM					[MBL],
	TC.Nome_Tp_Carga				[Tipo da Carga],
	ORG.Nome_Local					[Porto de Embarque],
	DST.Nome_Local					[Porto de Destino],
	Case when DC20.Id_DC='20' then 'YES' else 'NO' End [PDF - Doc Embarque],
	Case when DC44.Id_DC='44' then 'YES' else 'NO' End [PDF - BL Original],
	Case when DC29.Id_DC='29' then 'YES' else 'NO' End [PDF - CE Mercante],
	T42.Dt_Conclusao				[Redestinacao],
	B.Nome_BDP_Produto				[BDP Produto],
	U.Nome_Usuario					[Usuario],
	S.Status_Descricao				[Status]
from House_Imp_Mar HOU with(nolock)
	join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_Lim = HOU.Num_Proc_HIM
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo	
	join Job_Imp_Mar JOB with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM
	left JOIN Usuario U on U.Cd_Usuario = JOB.cd_usuario
	join Campo_Processo CP  with(nolock) on CP.Num_Proc = HOU.Num_proc_him and CP.Id_Campo = 143
	left join BDP_Produto B with(nolock) on B.ID_PD = CP.Campo_Dados
	left join Tipo_Carga TC with(nolock) on TC.Cd_Tp_Carga = LLP.Cd_Tp_Carga
	join Localidade ORG on ORG.Cd_Local = HOU.Cd_Org_HIM
	join Localidade DST on DST.Cd_Local = HOU.Cd_Dst_HIM
	Left join Tarefas_Processos	T42 With (Nolock) on T42.Num_Proc = HOU.Num_Proc_Him and T42.ID_Task = 42
	join Pedido_Ship PS With (Nolock) on PS.Num_Proc = HOU.Num_Proc_HIM
	left join Tipo_Status_Processo S on S.ID_Status = LLP.ID_Status
	Left Outer Join Doc_Anexos DC20 with(nolock) on HOU.Num_Proc_HIM = DC20.Num_Proc and DC20.Id_DC = '20'
	Left Outer Join Doc_Anexos DC44 with(nolock) on HOU.Num_Proc_HIM = DC44.Num_Proc and DC44.Id_DC = '44'
	Left Outer Join Doc_Anexos DC29 with(nolock) on HOU.Num_Proc_HIM = DC29.Num_Proc and DC29.Id_DC = '29'
Where
	LLP.Cd_Tp_Carga = 1 and
	CP.Campo_Dados in (1,3) and
	T42.Dt_Conclusao is null and
	HOU.Cd_Dst_HIM = 'SSZ' and
	LLP.ATA_Lim is null and
	Convert(datetime,HOU.Dt_Emis_HIM,103) > '2015-01-01' and 
	(Isnull(LLP.ID_Status,1) not in (9,8,5)) 	
order by 4


GO
