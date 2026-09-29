SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--/*** Create filters for Client group / Destination / Clearance Period ***//
--Set Parameters
--- Filtro por Modal = Air, Ocean, Others
-- Start date e end date devem considerar a data de desembaraço e não criação do job.

--[spTracking_KPIs_CHB_Sel]'GRUPO DOW','','2016-08-13','2016-11-11'

--'GRUPO DOW','','2016-10-03', '2016-10-03'

--spPessoaATL_Sel '%','T','Grupo%'


CREATE PROCEDURE [dbo].[spTracking_KPIs_CHB_Sel]
	@Grupo		varchar(50),
	@Destino	varchar(50),	
	@DtInicial	datetime,
	@DtFinal	datetime,
	@Modal		varchar(50)		
	
				
AS		
	
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

Select
	HOU.Dt_Emis				[Data do Registro],
	HOU.num_proc			[Job],
	(Case when HOU.Modal = 'Air Import' then CIA.Nome_Cia_Aer else ARM.Nome_Armador end)	[Armador],
	CONSIG.Apelido			[Consignatario],
	PG.Apelido				[Grupo],
	LD.Nome_Local			[Porto de Descarga],
	HOU.ATD					[ATD Date],
	HOU.ETA					[ETA Date],	
	HOU.ATA					[ATA Date],
	(Case when HOU.Modal = 'Air Import' then 'LCL' else TC.Nome_Tp_Carga end) [Tipo de Carga],
	PRO.Nome_BDP_Produto	[BDP Product],
	(case when CC.campo_dados ='1' then 'Sim' when CC.campo_dados ='2' then 'Não' else Null end) [Necessidade LI],
	[dbo].[fBusca_DATA_PO_Modal](Hou.num_proc,'5') [Data DI Number],		
	[dbo].[fBusca_Docs_PO_Modal](Hou.num_proc,'5')	[DI Number],
	Hou.Canal				[Channel],
	TER.Nome_Terminal		[Terminal],	
	TP16.Dt_Conclusao		[Chegada de Docs],
	TP27.Dt_Conclusao		[Digitação da DI],
	U27.Nome_Usuario		[Digitação da DI Usuario],
	TP65.Dt_Conclusao		[Conferencia de DI],
	U65.Nome_Usuario		[Conferencia de DI Usuario],
	TP20.Dt_Conclusao		[Deferimento de LI Previa],
	TP175.Dt_Conclusao		[Deferimento de LI Pos],
	TP21.Dt_Conclusao		[Liberação de BL],
	TP15.Dt_Conclusao		[Presença de Carga],
	TP63.Dt_Conclusao		[Documentos OK para Registro],
	TP4.Dt_Conclusao		[Desembaraco],
	TP11.Dt_Conclusao		[Emissão de NFE],
	TP108.Dt_Conclusao		[Recebimento de Danfe],
	TP7.Dt_Conclusao		[DOCS DISPONIVEIS P/TRANSP.],
	TP26.Dt_Conclusao		[Envio de Docs p/Faturamento]	
from vwHouse_Imp HOU
	Left  Join	Armador			ARM		with(nolock) on HOU.cd_armador	= ARM.cd_Armador and HOU.Modal <> 'Air Import'
	Left  Join	Cia_Aerea		CIA		with(nolock) on HOU.cd_armador	= CIA.Cd_Cia_Aer and HOU.Modal = 'Air Import'
	Join		Pessoa			CONSIG	with(nolock) on HOU.Cd_Consig		= CONSIG.Cd_Pes
	Join		Localidade		LD		with(nolock) on LD.cd_local			= HOU.Cd_Dst
	Left  Join	Tipo_Carga		TC		with(nolock) on HOU.Tp_Carga		= TC.Cd_Tp_Carga
	Left  Join	Pessoa_LLP		PLL		with(nolock) on CONSIG.Cd_Pes		= PLL.Cd_Pes
	Left  Join	Grupo			G		with(nolock) on G.cd_pes_grupo		= PLL.cd_pes_grupo
	Left  Join	pessoa			PG		with(nolock) on PG.cd_pes			= PLL.Cd_Pes_Grupo
	left  JOIN	Campo_Processo	CP143	with(nolock) on CP143.Num_Proc		= HOU.Num_Proc and CP143.Id_Campo = '143'
	left  JOIN	BDP_Produto		PRO		with(nolock) on CP143.Campo_Dados	= PRO.ID_PD
	left  join	Campo_Processo	CC		with(nolock) on CC.num_proc			= HOU.Num_Proc and CC.id_campo = 5	
	Left  Join	Terminal		TER			with(nolock) on HOU.Cd_Terminal = TER.Cd_Terminal
	Left  Join	Tarefas_Processos	TP16	with(nolock) on HOU.Num_Proc	= TP16.Num_Proc and TP16.ID_Task = '16'
	Left  Join	Tarefas_Processos	TP27	with(nolock) on HOU.Num_Proc	= TP27.Num_Proc and TP27.ID_Task = '27'
	Left  Join	Usuario				U27		with(nolock) on U27.cd_usuario	= TP27.Cd_Usuario
	Left  Join	Tarefas_Processos	TP65	with(nolock) on HOU.Num_Proc	= TP65.Num_Proc and TP65.ID_Task = '65'
	Left  Join	Usuario				U65		with(nolock) on U65.cd_usuario	= TP65.Cd_Usuario
	Left  Join	Tarefas_Processos	TP20	with(nolock) on HOU.Num_Proc	= TP20.Num_Proc and TP20.ID_Task = '20'
	Left  Join	Tarefas_Processos	TP175	with(nolock) on HOU.Num_Proc	= TP175.Num_Proc and TP175.ID_Task = '175'
	Left  Join	Tarefas_Processos	TP21	with(nolock) on HOU.Num_Proc	= TP21.Num_Proc and TP21.ID_Task = '21'
	Left  Join	Tarefas_Processos	TP15	with(nolock) on HOU.Num_Proc	= TP15.Num_Proc and TP15.ID_Task = '15'
	Left  Join	Tarefas_Processos	TP63	with(nolock) on HOU.Num_Proc	= TP63.Num_Proc and TP63.ID_Task = '63'
	Join	Tarefas_Processos	TP4		with(nolock) on HOU.Num_Proc	= TP4.Num_Proc and TP4.ID_Task = '4'
	Left  Join	Tarefas_Processos	TP11	with(nolock) on HOU.Num_Proc	= TP11.Num_Proc and TP11.ID_Task = '11'	
	Left  Join	Tarefas_Processos	TP108	with(nolock) on HOU.Num_Proc	= TP108.Num_Proc and TP108.ID_Task = '108'
	Left  Join	Tarefas_Processos	TP7		with(nolock) on HOU.Num_Proc	= TP7.Num_Proc and TP7.ID_Task = '7'
	Left  Join	Tarefas_Processos	TP26	with(nolock) on HOU.Num_Proc	= TP26.Num_Proc and TP26.ID_Task = '26'
where 
	--convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
	TP4.Dt_Conclusao between @DtInicial and @DtFinal
	and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL' or @Grupo = '')
	and (LD.Nome_Local = @Destino or @Destino = 'ALL' or @Destino = '')
	and (HOU.Modal = @Modal or @Modal = 'ALL' or @Modal = '' )
	and (CP143.Campo_Dados in (1,3))	
Order by 1



GO
