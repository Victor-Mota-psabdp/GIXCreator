SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Manutencao_Sel]

as

--**********Limpa envios para o SMART***********
delete ATL_INT.dbo.Smart_XML where Dt_Envio <= getdate()-21
delete ATL_INT.dbo.exchange_ODS where ExcDtEnvio <= getdate()-60
delete ATL_INT.dbo.exchange_ODS where ExcDataAlt <= getdate()-180 and ExcDtEnvio is null
delete ATL_INT.dbo.XML_Oxiteno where Dt_Ins <= getdate()-60
--**********Limpa envios para o SMART***********

--**********Limpa EXCHANGE***********
delete exchange where ExcDtEnvio <= getdate()-60 --and excReportManager <= getdate()-30  and excReportManager2 <= getdate()-30  and dt_envio_JMD_AX <= getdate()-30 
--**********Limpa EXCHANGE***********

--delete Exchange_Excim where Dt_Envio <= getdate()-160

--**********Limpa Historico do Sistema***********
delete hist_geral_Sistema where cd_tp_Ocor in ('45','49') and HSGData<=getdate()-120
--**********Limpa Historico do Sistema***********

--**********Limpa Baixa AX***********
delete dbo.Pgto_Fornecedor_AX where Dt_Upd_ATL is null or dt_ins <= getdate()-60

delete dbo.Pgto_Cliente_AX where Dt_Upd_ATL is null or dt_ins <= getdate()-60

delete dbo.Pgto_Fornecedor_AX where Dt_Upd_ATL is not null or dt_ins <= getdate()-90

delete dbo.Pgto_Cliente_AX where Dt_Upd_ATL is  not null or dt_ins <= getdate()-90

--**********Limpa Baixa AX***********

--**********Limpa LOG Usuario*********
delete Log_ATL where Start< = GETDATE()-360
--**********Limpa LOG Usuario*********

--DESATIVADO**********Limpa Custo Repor Manager***********
--delete Sistema_Exchange_Custo where Dt_Leitura <= GETDATE()-30
--**********Limpa Custo Repor Manager***********

--**************Limpa Emix Export***************

--Declare @Emix_Temp table(
--	ID bigint,
--	Insert_Dt datetime
--)
--insert @Emix_Temp
--select ID, Insert_DT  from ATL_INT.dbo.Emix_Retorno_Export_Item with(nolock)
--where Insert_Dt < = GETDATE()-30 

--delete ATL_INT.dbo.Emix_Retorno_Export_Item
--where ID in (select ID from @Emix_Temp)

--delete ATL_INT.dbo.Emix_Retorno_Export 
--where ID in (select ID from @Emix_Temp)

--**************Limpa Emix ***************
Declare @Emix_Temp table(
	ID bigint,
	Insert_Dt datetime
)
insert @Emix_Temp
select ID, Insert_DT  from ATL_INT.dbo.Emix_Retorno_Item with(nolock)
where Insert_Dt < = GETDATE()-30 

delete ATL_INT.dbo.Emix_Retorno_Item
where ID in (select ID from @Emix_Temp)

delete ATL_INT.dbo.Emix_Retorno 
where ID in (select ID from @Emix_Temp)

--**************Limpa GIX_XML ***************
DELETE G FROM ATL_INT.DBO.GIX_XML G 
left join ATLANTIS.DBO.House_Temp T with(nolock) on G.ID_Req = T.ID_Req 
left JOIN ATL_INT.DBO.GIX_Request_Header H  with(nolock) on G.Id_req = H.id_req	
WHERE
	H.SystemCode = '2'
	AND T.ID IS NULL
	and G.Dt_Ins <= GETDATE() -21

--**********Reorganiza Index das Tabelas***********
EXECUTE sp_msForEachTable 'SET QUOTED_IDENTIFIER ON; ALTER INDEX ALL ON ? REORGANIZE;'
--**********Reorganiza Index das Tabelas***********



GO
