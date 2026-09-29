SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Marcela 20/05/2020 inclusao de novos campos #100-187948
--[spATL_BDP_OTHERS_REL] '2017-01-01','2017-10-01','9 - ALL'  
--select * from vwSolPgtoCtaCte  
CREATE procedure [dbo].[spATL_BDP_OTHERS_REL]  
(  
 @DtInicial datetime,  
 @DtFinal datetime,  
 @tipo  varchar(30)  
)  
as  
  
  
select   
 PG.Apelido     [Grupo],  
 HBO.num_proc    [JOB],  
 HOU.Num_Proc_HBO   [JOB Others],  
 left(dbo.fBusca_Docs_PO_Modal(hbo.num_proc,1),500) [PO Number],
 loc.Nome_Local [Final Destination],
 PS.Num_CPF_CNPJ    [CNPJ],  
 PS.apelido     [Cliente],  
 HOU.Dt_Emis_HBO    [Data Criação],  
 T.Nome_TP_Servico   [Tipo Serviço],  
 S.Status_Descricao   [Status],   
 U.Nome_Usuario    [Criador JOB OTHERS],   
 TT.Nome_Tp_Tx    [Taxa],  
 TM.Nome_Tp_Moeda   [Currency],  
 CTA.Vlr_Org_HIA    [Value],  
 (Case when right(TT.CD_AX_Resultado,2)= '.2' then 'SIM' ELSE 'NO' END) [Custo BDP?],  
 CTA.DC_HIA     [DC],  
 PC.Apelido     [Debitor/ Creditor],  
 CTA.Dt_Ins_HIA    [Data do Lancamento],  
 SO.Solicitante     [Responsavel Lançamento],  
 SOL.ID      [Numero do Documento],  
 CTA.Dt_Ins_HIA    [Register Dt],
TP78.dt_conclusao [Emissão de NF de serviços],
TP26.dt_conclusao [Envio p/faturamento],
TP40.dt_conclusao [Envio da Prestação de contas]  
from House_BDP_OUT    HOU with(nolock)  
 JOIN LLP_BDP_OUT   LLP with(nolock)ON LLP.Num_Proc_LBO = HOU.Num_Proc_HBO  
 left join Tipo_Servico  T  with(nolock)ON T.Id_TP_Servico = LLP.Id_TP_Servico  
 left join Tipo_Status_BO S  with(nolock)ON S.ID_Status = LLP.ID_Status  
 JOIN Usuario    U with(nolock)ON U.Cd_Usuario = LLP.Cd_Usuario   
 left join JOB_HBO   HBO with(nolock)ON HBO.Num_Proc_hbo = HOU.Num_Proc_HBO  
 left join vwClienteALLJOBS V with(nolock)ON HBO.Num_Proc = V.num_proc  
 left join Pessoa   PS with(nolock)ON HOU.cd_cliente_hbo = PS.Cd_Pes  
 Left Join Pessoa_LLP  PLL with(nolock)ON PS.Cd_Pes = PLL.Cd_Pes  
 Left Join Grupo    G with(nolock)ON G.cd_pes_grupo=PLL.cd_pes_grupo  
 Join pessoa     PG With(nolock)ON PG.cd_pes=PLL.Cd_Pes_Grupo  
   
 left join vwcta_Cte   CTA with(nolock)ON CTA.Num_Proc_HIA = hou.Num_Proc_HBO  
 left JOIN Tipo_Taxa   TT with(nolock)ON TT.Cd_Tp_Tx = CTA.Cd_Tp_Tx  
 left JOIN Tipo_Moeda  TM with(nolock)ON TM.Cd_Tp_Moeda = CTA.Cd_Tp_Moeda  
 left join Pessoa   PC with(nolock)ON PC.Cd_Pes = CTA.Cd_Cred_Dev_HIA  
   
 left join vwSolPgtoCtaCteAprovadas SOL ON SOL.Num_Proc = CTA.Num_Proc_HIA AND SOL.DC = CTA.DC_HIA AND SOL.Cd_Tp_Tx = CTA.Cd_Tp_Tx  
 left join vwSolPgtoCtaCte SO on SO.[Register Number] = SOL.ID  
 left join vwHouse_Exp ve with(nolock) on ve.Num_Proc = hbo.Num_Proc
 left join vwHouse_Imp vi with(nolock) on vi.Num_Proc = hbo.Num_Proc
 left join Localidade loc with(nolock) on loc.cd_local = isnull(ve.Cd_DstFinal,vi.Cd_DstFinal) 

left join Tarefas_Processos TP78 with(nolock) on  TP78.Num_proc = hbo.Num_Proc_HBO and TP78.id_task=78 and TP78.dt_conclusao is not null
 left join Tarefas_Processos TP26 with(nolock) on TP26.Num_proc = hbo.Num_Proc_HBO and TP26.id_task=26 and TP26.dt_conclusao is not null
 left join Tarefas_Processos TP40 with(nolock) on TP40.Num_proc = hou.Num_Proc_HBO and TP40.id_task=40 and TP40.dt_conclusao is not null  
Where  
 --hou.Num_Proc_HBO = 'BOMAU201708001BR'  
 convert(datetime,HOU.Dt_Emis_HBO,103) between @DtInicial and @DtFinal  
 and (  
   (LLP.ID_Status =  left(@tipo,1))  
   or  
   (left(@tipo,1) = 0 and LLP.ID_Status <> 0)  
  )  
   
order by  
 convert(datetime,HOU.Dt_Emis_HBO,103)   
   
  
GO
