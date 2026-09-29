SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lindenberg, Rafael>
-- Create date: <03/10/2017>
-- Alter date:	<>
-- Description:	<Relatório de Controle Arktec - Ticket #100-74109>

--o ticket correto eh 100-66934
--[spATL_ExportSEA_rel]'GRUPO ALL', '2017-01-01', '2017-03-31'
-- =============================================

CREATE PROCEDURE  [dbo].[spATL_ExportSEA_rel] --[spReport_Export_Sel]'GRUPO ALL', '2016-10-01', '2016-10-07'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
	
AS
		
	declare @cd_pes_grupo varchar(10)
	declare @NomeGrupo as varchar(30)

select 
HOU.Num_Proc [BDP Ref.], 
Master [Consol Ref.], 
Booking_Number [Booking Number],
ETD [ETD Date],
ATD [ATD Date],
ETA [ETA Date],
ATA [ATA Date],
ARM.Nome_Armador	[Carrier],
Vessel,
Viagem Voyage,--inclui cadu
SHIP.Nome_Raz_Soc		[Shipper],
PF.Apelido				[Forwarder],
CONSIG.Nome_Raz_Soc		[Consignee],
LO.Nome_Local			[Origin],
LD.Pais_Local			[Country of Destination],
TP5.Dt_Conclusao		[Booking Confirmation Date],
HOU.Cut_Date			[Dead at Terminal - Date],
HOU.Dead_line			[Dead Line Draft - Date],
TP83.Dt_Conclusao		[Draft Received - Date],
TP84.Dt_Conclusao		[Draft Sent to Customer - Date],
TP1.Dt_Conclusao		[Pre-Alert Sending - Date],
Cd_Tp_Oper				[Incoterm],
U.Nome_Usuario			[CSR Name],
TP179.Dt_Conclusao [Sent ISF],
TP179.Dt_Conclusao [A.MS REGISTER],
TP182.Dt_Conclusao [SISCOSERV REGISTER],
TP186.Dt_Conclusao [VGM transmission],
Modal
from vwHouse_Exp HOU with(nolock)
Join Pessoa SHIP				with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
Join Pessoa CONSIG				with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
Join Localidade LO				with(nolock) on LO.cd_local = HOU.Cd_Org
Join Localidade LD				with(nolock) on LD.cd_local = HOU.Cd_Dst
Left Join Armador	ARM 		with(nolock) on HOU.cd_armador = ARM.cd_Armador
Left Join Usuario	U			with(nolock) on HOU.Cd_Usuario = U.Cd_Usuario
Left Join Pessoa	PF			with(nolock) on HOU.Cd_Forwarder = PF.Cd_Pes
Left join Pessoa_LLP	PL		with(nolock) on SHIP.Cd_Pes = PL.Cd_Pes
Left Join  Grupo		G		with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
Left Join  pessoa		PG		with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
Left Join Tarefas_Processos TP1 with(nolock) on HOU.Num_Proc = TP1.Num_Proc and TP1.ID_Task = '1'
Left Join Tarefas_Processos TP5 with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task = '5'
Left Join Tarefas_Processos TP83   with(nolock) on HOU.Num_Proc = TP83.Num_Proc and TP83.ID_Task = '83'
Left Join Tarefas_Processos TP84   with(nolock) on HOU.Num_Proc = TP84.Num_Proc and TP84.ID_Task = '84'
Left Join Tarefas_Processos TP178  with(nolock) on HOU.Num_Proc = TP178.Num_Proc and TP178.ID_Task = '178'
Left Join Tarefas_Processos TP179  with(nolock) on HOU.Num_Proc = TP179.Num_Proc and TP179.ID_Task = '179'
Left Join Tarefas_Processos TP182  with(nolock) on HOU.Num_Proc = TP182.Num_Proc and TP182.ID_Task = '182'
Left Join Tarefas_Processos TP186  with(nolock) on HOU.Num_Proc = TP186.Num_Proc and TP186.ID_Task = '186'
where 
	convert(Datetime,HOU.Dt_Emis,105)  between @DtInicial and @DtFinal 
	and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	--and HOU.Master <> 'JOB'
	and HOU.Modal = 'Ocean Export'
OPTION (HASH JOIN)
GO
