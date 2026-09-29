SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATL_FollowUp_V2_Rel] 'Grupo SOLENIS', '2020-01-01','2020-05-21'    
CREATE  procedure [dbo].[spATL_FollowUp_V2_Rel](    
 @Grupo varchar(50),    
 @DtInicial datetime,    
 @DtFinal datetime    
)    
as    
Declare @Cd_Grupo varchar(10)    
    
set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = @Grupo)    
Declare @Temp Table    
(    
	[Job Status] Varchar(100),    
	[Pendencias] Varchar(300), 
	[Comentários Operação]Varchar(500),   
	[Next Step] Varchar(100),    
	[BDP Ref.] varchar(16),
	[Cargo Type] Varchar(16),
	[Modal]	VArchar(16),    
	[Consignee]varchar(100),    
	[Planta]varchar(100),    
	[CNPJ] varchar(100),    
	[PO Number]varchar(500),    
	[Sales Order] varchar(500), 
	[Order Received-Date]datetime,   
	[Product Available-Date] datetime, 
	[Shipper] varchar(100),    
	[Product Description] varchar(500),    
	[ProductID] varchar(500),    
	Peso_Liquido_TOT Float,    
	[Invoice] varchar(500),    
	[Invoice Currency] varchar(100),    
	[Invoice Value]float,    
	[Payment Term] varchar(500),    
	[Incoterm] varchar(100),    
	[Recebimento do booking] datetime,    
	[Recebimento de copia de docs]datetime,   
	[Aprovação de Drafts] Datetime, 
	[Recebimento de docs originais]datetime,    
	[HBL/HAWB] Varchar(50),    
	[MBL/MAWB] Varchar(50),    
	[Armador] Varchar(100),    
	[ETD Original] datetime,    
	[Previsão do embarque(ETD)]datetime,    
	[Previsão de chegada(ETA)]datetime,    
	[Navio] varchar(500),    
	[Embarque confirmado(ATD)]datetime,    
	[Redestinação de Carga] Datetime,    
	[Confirmação de chegada(ATA)]datetime,    
	[Presenca de Carga] datetime,    
	[Docs OK para Registro] Datetime,
	[Liberação de BL] Datetime,    
	[Data do registro da DI] datetime,    
	[Numero da DI] varchar(500),    
	[Canal] varchar(50),    
	[Data do desembaraço] datetime,    
	[Solicitacao da Danfe] datetime,    
	[Recebimento da Danfe] datetime,    
	[Data entrega dos documentos para transporte] datetime,    
	[Pre-Faturamento] Datetime,    
	--[Envio de Faturamento] Datetime,    
	[Historico] varchar(max),    
	[Delivery Date Porto do PO(ETA original)]datetime,    
	[Urgente]varchar(50),    
	[Responsavel pelo Pedido] varchar(100),    
	[Country] varchar(100),    
	[Region] varchar(100),    
	[Data Base] datetime,    
	[Dias no Porto] int,
	[Embarque em atraso?] int,    
	[Chegada em atraso?] int,    
	[Situação]varchar(500)    
)    

insert @Temp    
Select     
		Null JobStatus,    
		'' Pendencias,    
		[dbo].[fBusca_HistoricoDescr](HOU.Num_Proc,117,getdate())   ,
		Null NextSteps,    
		HOU.Num_Proc [BDP Ref.],    
		TC.Nome_Tp_Carga  CargoType,
		Modal [Modal],
		CSN.Nome_Raz_Soc [Consignee],    
		DSF.Nome_Local [Planta],    
		(Case when LEN(CSN.Num_CPF_CNPJ) = 15 then    
		  substring(CSN.Num_CPF_CNPJ,2,2) + '.' + substring(CSN.Num_CPF_CNPJ,4,3) + '.' + substring(CSN.Num_CPF_CNPJ,7,3) + '/' + substring(CSN.Num_CPF_CNPJ,10,4) + '-' + substring(CSN.Num_CPF_CNPJ,14,2)     
		  else    
		  Case when LEN(CSN.Num_CPF_CNPJ) = 14 then    
		  substring(CSN.Num_CPF_CNPJ,1,2) + '.' + substring(CSN.Num_CPF_CNPJ,3,3) + '.' + substring(CSN.Num_CPF_CNPJ,6,3) + '/' + substring(CSN.Num_CPF_CNPJ,9,4) + '-' + substring(CSN.Num_CPF_CNPJ,13,2) else CSN.Num_CPF_CNPJ End End)    
		 [CNPJ],    
		dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,1) [PO Number],    
		dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,3)[Sales Order],    
		TP50.Dt_Conclusao [Order Received-Date],    
		TP237.Dt_Conclusao [Product Available-Date],
		SHP.Nome_Raz_Soc [Shipper],    
		PC.Produto_Descr [Product Description],    
		PC.cd_Proc_Cliente [ProductID],    
		PP.Peso_Liquido_TOT [Net Weight KG],    
		dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,2)[Invoice],    
		HOU.Moeda_invoice [Invoice Currency],    
		HOU.Vlr_invoice [Invoice Value],    
		TP.Descricao_Termo [Payment Term],    
		HOU.Cd_Tp_Oper [Incoterm],    
		TP5.Dt_Conclusao [Recebimento do booking],    
		TP109.Dt_Conclusao [Recebimento de copia de docs],   
		TP41.Dt_Conclusao [Aprovação de Draft], 
		TP16.Dt_Conclusao [Recebimento de docs originais],    
		hou.HAWB [HBL],    
		HOU.MAWB [MBL],    
		HOU.carriername [Armador],       
		convert(datetime,CP127.Campo_Dados,105)   OriginalETD,        
		HOU.ETD [Previsão do embarque(ETD)],    
		Hou.ETA [Previsão de chegada(ETA)],    
		HOU.Vessel [Navio],    
		HOU.ATD [Embarque confirmado(ATD)],    
		TP218.Dt_Conclusao [Redestinação de Carga],    
		HOU.ATA [Confirmação de chegada(ATA)],    
		TP15.Dt_Conclusao [Presença de Carga],   
		TP63.Dt_Conclusao [OK Para registro],   
		TP21.Dt_Conclusao [Liberação de BL],    
		dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,5) [Data do registro da DI],    
		dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,5) [Numero da DI],    
    
		HOU.Canal [Canal],    
		TP4.Dt_Conclusao [Data do desembaraço],    
		TP67.Dt_Conclusao [Solicitacao de Danfe],    
		TP108.Dt_Conclusao [Recebimento da Danfe],    
		TP7.Dt_Conclusao [Data entrega dos documentos para transporte],    
		TP79.Dt_Conclusao [Pre-Faturamento],    
		--dbo.fBusca_HistoricoDescr_Completo(hou.Num_Proc) [Historico],    
		--dbo.fBusca_HistoricoDescr_Tipo_S_Completo(hou.Num_Proc) [Historico],    
		dbo.fBusca_HistoricoDescr(hou.Num_Proc,116,NULL) [Historico],
		HOU.Original_ETA [Delivery Date Porto do PO(ETA original)],    
		isnull(V36.Descricao,'NÃO') [Urgente],    
		UR.Nome_Usuario [Responsavel pelo Pedido],    
		POrg.Nome_Pais [Country],    
		ROrg.Nome_Regiao [Region],    
		CONVERT(datetime,getdate(),103) [Data Base],    
		Null [Dias no Porto],
		NULL [Embarque em atraso?],    
		NULL [Chegada em atraso?],    
		NULL [Situação]    
from vwHouse_Imp HOU with(nolock)    
	left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig    
	left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo    
	left join pessoa PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo    
	join Pessoa CSN with(nolock) on HOU.Cd_Consig = CSN.Cd_Pes    
	join Localidade DSF with(nolock) on HOU.Cd_DstFinal = DSF.Cd_Local    
	join Pessoa SHP with(nolock) on HOU.Cd_Export = SHP.Cd_Pes    
	left join vwPedidoShipxPedido PP with(nolock) on HOU.Num_Proc = PP.Num_Proc     
	left join Produto_Cliente PC with(nolock) on PP.Cd_Produto = PC.cd_prod    
	left join Campo_Processo CP87 with(nolock) on HOU.Num_Proc = CP87.Num_Proc and CP87.Id_Campo = 87    
	left join Campo_Processo CP36 with(nolock) on HOU.Num_Proc = CP36.Num_Proc and CP36.Id_Campo = 36    
	left join Verdade V36 with(nolock) on CP36.Campo_Dados = V36.Id    
	left join Termo_Pagamento TP with(nolock) on CP87.Campo_Dados = TP.Cd_Termo    
	left join Tarefas_Processos TP5 with(nolock) on HOU.Num_Proc = TP5.Num_Proc and TP5.ID_Task =5    
	left join Tarefas_Processos TP109 with(nolock) on HOU.Num_Proc = TP109.Num_Proc and TP109.ID_Task =109    
	left join Tarefas_Processos TP16 with(nolock) on HOU.Num_Proc = TP16.Num_Proc and TP16.ID_Task =16    
	left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task =4    
	left join Tarefas_Processos TP7 with(nolock) on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task =7    
	left join Tarefas_Processos TP108 with(nolock) on HOU.Num_Proc = TP108.Num_Proc and TP108.ID_Task =108    
	left join Tarefas_Processos TP50 with(nolock) on HOU.Num_Proc = TP50.Num_Proc and TP50.ID_Task =50    
	left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task =40    
	left join Usuario_Cliente UR with(nolock) on PP.cd_CSRID = UR.Cd_Usuario    
	join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local    
	left join Pais POrg with(nolock) on ORG.Cd_Pais = POrg.cd_pais    
	left join Regiao ROrg with(nolock) on ROrg.cd_regiao = ORG.cd_regiao    
	left join Campo_Processo CP143 with(nolock) on HOU.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143    
	left join Campo_Processo CP127 with(nolock) on HOU.Num_Proc = CP127.Num_Proc and CP127.Id_Campo = 127 and len(CP127.campo_dados)=10    
	left join Tarefas_Processos TP15 with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task =15    
	left join Tarefas_Processos TP218 with(nolock) on HOU.Num_Proc = TP218.Num_Proc and TP218.ID_Task =218    
	left join Tarefas_Processos TP67 with(nolock) on HOU.Num_Proc = TP67.Num_Proc and TP67.ID_Task =67    
	  left join Tarefas_Processos TP21 with(nolock) on HOU.Num_Proc = TP21.Num_Proc and TP21.ID_Task =21    
	left join Tarefas_Processos TP79 with(nolock) on HOU.Num_Proc = TP79.Num_Proc and TP79.ID_Task =79    
	left join Tarefas_Processos TP41 with(nolock) on HOU.Num_Proc = TP41.Num_Proc and TP41.ID_Task =41    
		left join Tarefas_Processos TP63 with(nolock) on HOU.Num_Proc = TP63.Num_Proc and TP63.ID_Task =63
	Left Join Tipo_Carga TC on TC.Cd_Tp_Carga = hou.tp_carga
		left join Tarefas_Processos TP237 with(nolock) on HOU.Num_Proc = TP237.Num_Proc and TP237.ID_Task =237      
	
where     
 HOU.ID_Status not in(9,7,8)    
 and CP143.Campo_Dados in (1,3)     
 and TP40.Dt_Conclusao is null     
 and (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')    
 and convert(datetime,HOU.dt_emis,103) between @DtInicial and @DtFinal    
 
option(hash join)    

 --Embarque em atraso?    
update @Temp set     
[Embarque em atraso?] =     
DATEDIFF(DAY,  [Data Base],[Delivery Date Porto do PO(ETA original)])     
where SUBSTRING([BDP Ref.],2,1) = 'M' and [Recebimento do booking] is  null    
    
--Chegada em atraso?    
 --Ocean    
 update @Temp set     
 [Chegada em atraso?] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
 then DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)])     
 else DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)])end)     
 where SUBSTRING([BDP Ref.],2,1) = 'M' and  [Recebimento do booking] is not null    
 --Not Ocean    
 update @Temp set     
 [Chegada em atraso?] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
 then DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)])     
 else DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)])end)     
 where SUBSTRING([BDP Ref.],2,1) <> 'M'     
    
--Situação    
 --Ocean    
 update @Temp set     
 [Situação] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
    then     
   (Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)]) >= 6     
      Then 'ANTECIPADO - Chegada Confirmada'    
    else       
    'ATRASADO - Chegada Confirmada'    
    End)    
 else     
      
  (Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)]) >= 6    
     Then 'ANTECIPADO - Em Trânsito ou com Dados de Embarque'     
   else    
   'ATRASADO - Em Trânsito ou com Dados de Embarque'    
   End)    
 end)     
 where SUBSTRING([BDP Ref.],2,1) = 'M' and  [Recebimento do booking] is not  null    
 --Not Ocean    
 update @Temp set     
 [Situação] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
    then     
   (Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)]) >= 6     
      Then 'ANTECIPADO - Chegada Confirmada'    
    else       
    'ATRASADO - Chegada Confirmada'    
    End)    
 else     
      
  (Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)]) >= 6    
     Then 'ANTECIPADO - Em Trânsito ou com Dados de Embarque'     
   else    
   'ATRASADO - Em Trânsito ou com Dados de Embarque'    
   End)    
 end)      
 where SUBSTRING([BDP Ref.],2,1) <> 'M'     
     
 update @Temp set     
  [Situação] =     
  (Case when  [Region] = 'Asia' Then    
   (Case when DATEDIFF(DAY,  [Data Base],[Delivery Date Porto do PO(ETA original)]) < 55    
      Then 'ATRASADO - Sem Dados de Embarque'     
     else    
     'OK - Sem Dados de Embarque'    
     End)    
    else    
     (Case when DATEDIFF(DAY,  [Data Base],[Delivery Date Porto do PO(ETA original)]) < 40    
      Then 'ATRASADO - Sem Dados de Embarque'     
     else    
     'OK - Sem Dados de Embarque'    
     End)    
  End)    
 where SUBSTRING([BDP Ref.],2,1) = 'M' and [Recebimento do booking] is  null    
    
    
update @Temp set     
 [Situação] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
    then     
   (Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)]) between -5 and 5     
      Then 'OK - Chegada Confirmada'    
   else    
   [Situação]    
    End)    
 else     
      
  (Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)]) between -5 and 5     
     Then 'OK - Em Transito ou com Dados de Embarque'     
  else    
  [Situação]    
   End)    
 end)     
 where SUBSTRING([BDP Ref.],2,1) = 'M' and  [Recebimento do booking] is not  null    
     
 update @Temp set     
 [Situação] =      
 (Case when [Confirmação de chegada(ATA)]  is not null     
    then     
   (Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Porto do PO(ETA original)]) between -5 and 5     
      Then 'OK - Chegada Confirmada'    
   else    
   [Situação]    
    End)    
 else     
      
  (Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Porto do PO(ETA original)]) between -5 and 5     
     Then 'OK - Em Transito ou com Dados de Embarque'     
     else    
     [Situação]    
   End)    
 end)     
 where SUBSTRING([BDP Ref.],2,1) <> 'M'    
    
 -- STATUS JOB STATUS    
 /*    
  Orde    
    
    
    
 */    
    
 --Historico Pendencia    
 Update @Temp    
   SET     
    [Job Status]='01 - Ordem Recebida',    
    [Next Step]='Recebimento de Booking'    
 Where    
   [Recebimento do booking] is null     
 
 
 Update @Temp    
   SET     
    [Job Status]='02 - Booking Recebido - Aguardando Embarque',    
    [Next Step]='Confirmar Embarque'    
 Where    
   [Embarque confirmado(ATD)] is null and [Recebimento do booking] is not null     
 /*   
 Update @Temp    
   SET [Job Status]='03 - Aguardando Embarque',    
   [Next Step]='Confirmar Embarque'    
 Where    
   [Embarque confirmado(ATD)] is null and [Recebimento do booking] is not null and [Recebimento de copia de docs] is not null    
   */ 
 Update @Temp    
   SET [Job Status]='04 - Embarque confirmado',    
   [Next Step]='Acompanhar Chegada'    
    
 Where    
   [Embarque confirmado(ATD)] is not null and [Recebimento de docs originais] is null and [Confirmação de chegada(ATA)] is null     
    
 Update @Temp    
   SET [Job Status]='05 - Documentos recebidos - Aguardando chegada',    
   [Next Step]='Acompanhar Chegada'    
 Where    
   [Embarque confirmado(ATD)] is not null and [Recebimento de docs originais] is not null and [Confirmação de chegada(ATA)] is null     
    
    
     
 Update @Temp    
   SET [Job Status]='06 - Chegada Confirmada - Aguardando Presença de carga',    
    [Next Step]='Presença de Carga'    
    
 Where    
   [Confirmação de chegada(ATA)] is not null and [Presenca de Carga] is null     
    
     
    Update @Temp    
   SET [Job Status]='07 - Presença de carga confirmada - Aguardando Registro da DI',    
   [Next Step]='Registro da DI'    
 Where    
   [Presenca de Carga] is not null and [Data do registro da DI] is null     
    
  Update @Temp    
   SET [Job Status]='08 - Registro da DI Confirmado- aguardando parametrização',    
   [Next Step]='Parametrização'    
    
 Where    
   [Data do registro da DI] is not  null   and [Canal] is  null    
    
      
 Update @Temp    
   SET [Job Status]='09 - Parametrização confirmada',    
   [Next Step] = 'Desembaraço'    
        
 Where    
   [Canal] is  not null and    
   [Data do desembaraço] is null     
    
    
 Update @Temp    
   SET [Job Status]='10 - Desembaraço Confirmado - Solicitar DANFE',    
   [Next Step]='Solicitar DANFE'    
 Where    
   [Data do desembaraço] is not null and [Solicitacao da Danfe] is null    
    
    
     
 Update @Temp    
   SET [Job Status]='11 - Solicitação DANFE Enviada - Aguardando DANFE ',    
   [Next Step]='Danfe Recebida'    
 Where    
   [Solicitacao da Danfe] is not null and [Recebimento da Danfe] is null    
    
     
 Update @Temp    
   SET [Job Status]='12 - DANFE Recebido',    
   [Next Step]='Entrega de Docs para Trasporte'    
    
 Where    
   [Recebimento da Danfe] is not null  and [Data entrega dos documentos para transporte] is null    
    
    
 Update @Temp    
   SET [Job Status]='13 - Docs entregue para Tranporte',    
   [Next Step]='Pre-Faturamento'    
    
 Where    
  [Data entrega dos documentos para transporte] is not null and [Pre-Faturamento] is null    
    
 Update @Temp    
   SET [Job Status]='14 - Pre-Faturamento Enviado',    
   [Next Step]='Envio Prestacao'    
    
 Where    
  [Pre-Faturamento] is not null     
    
  --- Pendencias    
   /*
  Update @temp    
   Set [Pendencias]=[dbo].[fBusca_HistoricoDescr]([BDP Ref.],117,getdate())    
    
  Update @Temp    
   Set [Pendencias]='Aguardando documento original e liberação de BL'    
  where    
   [Liberação de BL] is null and [Recebimento de docs originais] is null and [Pendencias] is null   and [Embarque confirmado(ATD)]  >=getdate()-5    
    
  Update @Temp    
   Set [Pendencias]='Aguardando documento original'    
  where    
    [Recebimento de docs originais] is null and [Pendencias] is null  and [Embarque confirmado(ATD)]  >=getdate()-5   
    
  Update @Temp    
   Set [Pendencias]='Aguardando liberação de BL'    
  where    
   [Liberação de BL] is null and [Pendencias] is null    and [Embarque confirmado(ATD)]  >=getdate()-5
    
  Update @Temp    
   Set [Pendencias]='Redestinação Pendente'    
  where    
   [Pendencias] is null and [Redestinação de Carga] is null and ([Confirmação de chegada(ATA)] is not null or [Delivery Date Porto do PO(ETA original)] <=getdate()+5)    
   and [Liberação de BL] is not null and  [Recebimento de docs originais] is not null and [Embarque confirmado(ATD)] is not null  and [Embarque confirmado(ATD)]  >=getdate()-5
    
    
  Update @Temp    
   Set [Pendencias]='Redestinação Pendente, Aguardando Liberação de BL'    
  where    
   [Pendencias] is null and [Redestinação de Carga] is null and ([Confirmação de chegada(ATA)] is not null or [Delivery Date Porto do PO(ETA original)] <=getdate()+5)    
   and [Liberação de BL] is  null and  [Recebimento de docs originais] is not null and [Embarque confirmado(ATD)] is not null     
    
  Update @Temp    
   Set [Pendencias]='Redestinação Pendente, Aguardando Liberação de BL,Aguardando documento original '    
  where    
   [Pendencias] is null and [Redestinação de Carga] is null and ([Confirmação de chegada(ATA)] is  null or [Delivery Date Porto do PO(ETA original)] <=getdate()+5)    
   and [Liberação de BL] is  null and  [Recebimento de docs originais] is  null and [Embarque confirmado(ATD)] is not null     
     
      
  Update @Temp    
   Set [Pendencias]='Redestinação Pendente, Aguardando documento original '    
  where    
   [Pendencias] is null and [Redestinação de Carga] is null and ([Confirmação de chegada(ATA)] is  null or [Delivery Date Porto do PO(ETA original)] <=getdate()+5)    
   and [Liberação de BL] is  not null and  [Recebimento de docs originais] is  null and [Embarque confirmado(ATD)] is not null     
   */
    Update
		@temp
			Set [Dias no Porto]=cast(getdate()-[Confirmação de chegada(ATA)] as int)
	where 
		[Confirmação de chegada(ATA)] is not null 


  Update
	@Temp 
		SEt [Pendencias]='|BASF - aguardando dados de booking'
	Where
		[Recebimento do booking] is null and [Shipper]='SOLENIS SWITZERLAND GMBH - BASF VP'

     Update
	@Temp 
		SEt [Pendencias]=[Pendencias]+'|Embarque Atrasado'
	Where
		[Embarque confirmado(ATD)] is null and [Previsão do embarque(ETD)] <=getdate()-1

	Update
	@Temp 
		SEt [Pendencias]=[Pendencias]+'|ETD Original Vencido'
	Where
		[Embarque confirmado(ATD)] is null and [ETD Original] <=getdate()-1

   Update
	@Temp 
		SEt [Pendencias]=[Pendencias] +'|Delivery Dt'
	Where
		[Order Received-Date] is not null and [Shipper] like 'SOLEN%' and [Product Available-Date] is null and [Shipper] not  in ('SOLENIS SWITZERLAND GMBH - BASF VP','SOLENIS TECHNOLOGIES MSP ZAO')

   Update 
		@Temp   
		Set [Pendencias]=[Pendencias] +'|Redestinação Pendente'
   where 
		[Embarque confirmado(ATD)] is not null and [Redestinação de Carga] is null and ([Confirmação de chegada(ATA)] is not  null or [Previsão de chegada(ETA)] <=getdate()+5)  
		and [Cargo Type] <> 'LCL'
   Update @Temp   
		Set [Pendencias]=[Pendencias] + '|Documento Original Pendente'
   where 
		[Embarque confirmado(ATD)] is not null and [Recebimento de docs originais] is null and ([Previsão de chegada(ETA)] <=getdate()-3)  

    Update @Temp 
		Set [Pendencias]=[Pendencias] + '|Liberação de BL Pendente|'
   where 
	[Embarque confirmado(ATD)] is not null and	[Liberação de BL] is null and ([Confirmação de chegada(ATA)] is not null )  


	Update @Temp 
		Set [Pendencias]=[Pendencias] + '|ETA Vencido'
   where 
	[Confirmação de chegada(ATA)] is null and	DATEDIFF(DAY, getdate(), [Previsão de chegada(ETA)])<-2  and [Embarque confirmado(ATD)] is not null

 
	Update 
		@Temp   
		Set [Pendencias]=[Pendencias] + '|Recebimento de Copias de Documentos'
   where 
		[Recebimento de copia de docs] is null and DATEDIFF(DAY, getdate(), [Embarque confirmado(ATD)])<-2   
	
	Update @Temp   
			Set [Pendencias]=[Pendencias] + '|Draft para ser aprovado'
   where 
			[Recebimento de copia de docs] <=getdate()-2 and [Aprovação de Drafts] is null   
	

select * from @Temp    
    
    
    
    

GO
