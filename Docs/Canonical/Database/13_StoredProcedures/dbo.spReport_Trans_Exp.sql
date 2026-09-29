SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_Trans_Exp] --[spReport_Trans_Exp] 'GRUPO ALL', '2016-10-01', '2016-10-07'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

select 
HOU.Num_Proc_HEM [BDP Ref.],
HOU.Num_Proc_MEM [CONSOLIDADA ],
P.Apelido [Shipper],
PG.Apelido [Group Name],
LO.Nome_Local		[Origin],
LD.Nome_Local		[Destination],
ARM.Nome_Armador	[Carrier],
LLP.ETD_Lem [ETD Date],
LLP.ATD_Lem [ATD Date],
LLP.ETA_Lem [ETA Date],
LLP.ATA_Lem [ATA Date],
LLP.DL_Draft_Lem [Dead Line Draft - Date],
LLP.DL_Cargo_Lem [Dead at Terminal - Date],
TP186.Dt_Conclusao [TRANSMISSÃO DO VGM],
TP151.Dt_Conclusao [ENVIO DE MAS/ENS AO DESTINO],
TP152.Dt_Conclusao [ENVIO DE ISF AO DESTINO],
TP150.Dt_Conclusao [PAGTO FRETE E TAXAS AO ARMADOR],
TP21.Dt_Conclusao [BL Released - Date],
TP134.Dt_Conclusao [Booking Confirmation Date],
TP1.Dt_Conclusao [Pre-Alert Sending - Date],
TP182.Dt_Conclusao [ENVIO DE SISCOSERV],
Case when DC2.Id_DC='2' then 'YES' else 'NO' End	[PDF - Invoice],
Case when DC20.Id_DC='20' then 'YES' else 'NO' End	[PDF - BL],
TS.status_descricao [Process Status],
[dbo].[fBusca_HistoricoDescr_Completo](HOU.Num_Proc_HEM) [Cd_BDP Last Historic],
TP905.Dt_Conclusao [REGISTRO DE PROFIT]
 from House_Exp_Mar	HOU	with(nolock)
Join LLP_Exp_Mar		LLP with(nolock) on HOU.Num_Proc_HEM = LLP.Num_Proc_Lem
Join Tipo_Status_Processo TS	with(nolock) on LLP.ID_Status = TS.ID_status
Left join Pessoa		P	with(nolock) on HOU.Cd_Export_HEM= P.Cd_Pes
Left join Pessoa_LLP	PL	with(nolock) on P.Cd_Pes = PL.Cd_Pes
Left Join  Grupo		G	with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
Left Join  pessoa		PG	with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
Join Localidade			LO	with(nolock) on LO.cd_local = HOU.Cd_Org_HEM
Join Localidade			LD	with(nolock) on LD.cd_local = HOU.Cd_Dst_HEM
Left Join Armador		ARM with(nolock) on LLP.Cd_Armador_Lem = ARM.cd_Armador
Left Join Doc_Anexos DC2	with(nolock) on HOU.Num_Proc_HEM = DC2.Num_Proc and DC2.Id_DC = '2'
Left Join Doc_Anexos DC20 with(nolock) on Hou.Num_Proc_HEM = DC20.Num_Proc and DC20.Id_DC = '20'
Left Join Tarefas_Processos TP186  with(nolock) on HOU.Num_Proc_HEM = TP186.Num_Proc and TP186.ID_Task = '186'
Left Join Tarefas_Processos TP151  with(nolock) on HOU.Num_Proc_HEM = TP151.Num_Proc and TP151.ID_Task = '151'
Left Join Tarefas_Processos TP152  with(nolock) on HOU.Num_Proc_HEM = TP152.Num_Proc and TP152.ID_Task = '152'
Left Join Tarefas_Processos TP150  with(nolock) on HOU.Num_Proc_HEM = TP150.Num_Proc and TP150.ID_Task = '150'
Left Join Tarefas_Processos TP21  with(nolock) on HOU.Num_Proc_HEM = TP21.Num_Proc and TP21.ID_Task = '21'
Left Join Tarefas_Processos TP134  with(nolock) on HOU.Num_Proc_HEM = TP134.Num_Proc and TP134.ID_Task = '134'
Left Join Tarefas_Processos TP1  with(nolock) on HOU.Num_Proc_HEM = TP1.Num_Proc and TP1.ID_Task = '1'
Left Join Tarefas_Processos TP182  with(nolock) on HOU.Num_Proc_HEM = TP182.Num_Proc and TP182.ID_Task = '182'
Left Join Tarefas_Processos TP905  with(nolock) on HOU.Num_Proc_HEM = TP905.Num_Proc and TP905.ID_Task = '905'
where 
	convert(Datetime,HOU.Dt_Emis_HEM,105)  between @DtInicial and @DtFinal 
	and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and Hou.Num_Proc_MEM <> 'JOB'
GO
