SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_ControlStagesExport_Rel '2018-03-19' 
CREATE procedure [dbo].[spATL_ControlStagesExport_Rel]
(

@ETD datetime

)


as
select
H.Num_Proc [BDP Ref.],
C.Master [Consol Ref.],
H.Modal [Modal],
BP.Nome_BDP_Produto [BDP Product],
PG.Apelido [Group Name],
SH.Nome_Raz_Soc [Shipper],
dbo.fBusca_Docs_PO_Modal_COALESCE(H.Num_Proc,3) [Sales Order],
dbo.[fBusca_Docs_PO_Modal_COALESCE](H.Num_Proc,1) [PO Number],
dbo.[fBusca_Docs_PO_Modal_COALESCE](H.Num_Proc,2)[Invoice],
ORG.Nome_Local [Origin],
Dst.Nome_Local[Destination],
H.Dead_line [Dead Line Draft - Date],
H.Cut_Date [Cut-off - Date],
T66.Dt_Conclusao [Draft EXP - Date],
t158.Dt_Conclusao [REVISÃO DE DRAFT],
T4.Dt_Conclusao [Customs Clearance Date],
dbo.fBusca_Docs_PO_Modal_COALESCE(H.Num_Proc,4)[RE Number],
dbo.fBusca_Docs_PO_Modal_COALESCE(H.Num_Proc,12)[DDE Number],
T189.Dt_Conclusao [Port Entry Date],
H.Vessel [Vessel],
H.Viagem [Voyage],
AR.Nome_Armador [Carrier],
AG.Apelido [Agent],
H.ETD [ETD Date],
H.ATD [ATD Date],
H.Booking_Number [Booking Number],
T10.Dt_Previsao [Plant Exit Date - Estimated],
T10.Dt_Conclusao [Plant Exit Date - Actual],
dbo.fBusca_TipoDocCliente('D',H.Num_Proc,10) [NF Date],
TM.Nome_Terminal [Terminal],
MC.Num_Cont_EM[Containers],
T161.Dt_Conclusao [DEPÓSITO DE CONTEINER NO TERMINAL],
T160.Dt_Conclusao [ABERTURA DE GATE],
T157.Dt_Conclusao [PROTOCOLO DE MDGF],
CI.Dt_Envio_VGM [VGM REPORTED DATE],
CI.Peso_Bruto_EM_VGM [VGM GROSS WEIGHT],
(case when CI.Metodo_VGM = 1 then '1-Weighing Packed Container' else  
case when CI.Metodo_VGM = 2 then '2-Weighing All Packages and Cargo Items' 
	else NULL end end)  [VGM METHOD],
T186.Dt_Conclusao [TRANSMISSÃO VGM ],
T187.Dt_Conclusao [RE-TRANSMISSÃO VGM ],
H.DL_VGM [DEAD LINE VGM],
T188.Dt_Conclusao [RECEBIMENTO ARMADOR VGM],
DATENAME(MONTH,T4.Dt_Conclusao) [Month of Clearance],
U.Nome_Usuario [CSR Name],
cast(TSP.ID_Status as varchar(10)) + ' - ' + TSP.Status_Descricao [Process Status],
--[dbo].[fBusca_HistoricoDescr](H.Num_Proc,0,getdate()) [Last Historic]
HU.HSDDescricao [Last Historic]
from vwHouse_Exp H with(nolock)
left join vwCliente		 C		with(nolock) on H.Num_Proc = C.num_proc
left join Campo_Processo C143	with(nolock) on C.num_proc = C143.Num_Proc and C143.Id_Campo = '143'
left join BDP_Produto	 BP		with(nolock) on C143.Campo_Dados = BP.ID_PD
left Join Pessoa_LLP	 PLL	with(nolock) on PLL.Cd_Pes=H.Cd_Export
left join Grupo		     G		with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
left join pessoa		 PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
join Pessoa				 SH		with(nolock) on  H.Cd_Export = SH.Cd_Pes
join Localidade			 ORG	with(nolock) on H.Cd_Org = ORG.Cd_Local
join Localidade			 DST	with(nolock) on H.Cd_Dst = DST.Cd_Local
left join Tarefas_Processos T66 with(nolock) on H.Num_Proc = T66.Num_Proc and T66.ID_Task = 66
left join Tarefas_Processos T158 with(nolock) on H.Num_Proc = T158.Num_Proc and T158.ID_Task = 158
left join Tarefas_Processos T4  with(nolock) on H.Num_Proc = T4.Num_Proc and T4.ID_Task = 4
left join Tarefas_Processos T189 with(nolock) on H.Num_Proc = T189.Num_Proc and T189.ID_Task = 189
left join Armador		 AR		with(nolock) on H.Cd_Armador = AR.Cd_Armador
left join Pessoa		 AG		with(nolock) on  H.cd_Agente = AG.Cd_Pes
left join Tarefas_Processos T10 with(nolock) on H.Num_Proc = T10.Num_Proc and T10.ID_Task = 10
left join Terminal		 TM		with(nolock) on H.Cd_Terminal = TM.Cd_Terminal
left join Tarefas_Processos T161 with(nolock) on H.Num_Proc = T161.Num_Proc and T161.ID_Task = 161
left join Tarefas_Processos T160 with(nolock) on H.Num_Proc = T160.Num_Proc and T160.ID_Task = 160
left join Tarefas_Processos T157 with(nolock) on H.Num_Proc = T157.Num_Proc and T157.ID_Task = 157
left join Usuario		 U		 with(nolock) on H.Cd_Usuario = U.Cd_Usuario
left join Tipo_Status_Processo TSP with(nolock) on H.ID_Status = TSP.ID_Status
left join Container_Hou_Exp_Mar HC with(nolock) on H.Num_Proc = HC.Num_Proc_HEM
left join Container_Mas_Exp_Mar MC with(nolock) on HC.Num_Proc_MEM = MC.Num_Proc_MEM and HC.Item_Cont_EM = MC.Item_Cont_EM
left join Container_Additional_Info CI with(nolock) on HC.Num_Proc_HEM = CI.num_proc and replace(MC.Num_Cont_EM,'-','') = CI.num_cont and CI.ativo = 1
left join Tarefas_Processos T186 with(nolock) on H.Num_Proc = T186.Num_Proc and T186.ID_Task = 186
left join Tarefas_Processos T187 with(nolock) on H.Num_Proc = T187.Num_Proc and T187.ID_Task = 187
left join Tarefas_Processos T188 with(nolock) on H.Num_Proc = T188.Num_Proc and T188.ID_Task = 188
left join Hist_Geral_UltimoHistorico HU with(nolock) on H.Num_Proc = HU.HSGProcesso
where H.ETD >= @ETD
order by H.ETD
option(hash join)


GO
