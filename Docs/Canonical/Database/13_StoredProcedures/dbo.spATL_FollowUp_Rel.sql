SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_FollowUp_Rel 'Grupo SOLENIS', '2019-01-01','2019-04-04'
CREATE procedure [dbo].[spATL_FollowUp_Rel](
 @Grupo varchar(50),
 @DtInicial datetime,
 @DtFinal datetime
)
as
Declare @Cd_Grupo varchar(10)

set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa P with(nolock) join Grupo G with(nolock) on P.Cd_Pes = G.Cd_Pes_Grupo where P.Apelido = @Grupo)
Declare @Temp Table
(

[BDP Ref.] varchar(16),
[Consignee]varchar(100),
[Planta]varchar(100),
[CNPJ] varchar(100),
[PO Number]varchar(500),
[Sales Order] varchar(500),
[Order Received-Date]datetime,
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
[Recebimento de docs originais]datetime,
[HBL/HAWB] Varchar(50),
[MBL/MAWB] Varchar(50),
[Armador] Varchar(100),
[Previsão do embarque(ETD)]datetime,
[Previsão de chegada(ETA)]datetime,
[Navio] varchar(500),
[Embarque confirmado(ATD)]datetime,
[Confirmação de chegada(ATA)]datetime,
[Numero da DI] varchar(500),
[Data do registro da DI] datetime,
[Data do desembaraço] datetime,
[Canal] varchar(50),
[Recebimento da Danfe] datetime,
[Data entrega dos documentos para transporte] datetime,
[Historico] varchar(max),
[Delivery Date Planta do PO(ETA original)]datetime,
[Urgente]varchar(50),
[Responsavel pelo Pedido] varchar(100),
[Country] varchar(100),
[Region] varchar(100),
[Data Base] datetime,
[Embarque em atraso?] int,
[Chegada em atraso?] int,
[Situação]varchar(500)
)
insert @Temp
Select 
HOU.Num_Proc [BDP Ref.],
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
TP16.Dt_Conclusao [Recebimento de docs originais],
hou.HAWB [HBL],
HOU.MAWB [MBL],
HOU.carriername [Armador],
HOU.ETD [Previsão do embarque(ETD)],
Hou.ETA [Previsão de chegada(ETA)],
HOU.Vessel [Navio],
HOU.ATD [Embarque confirmado(ATD)],
HOU.ATA [Confirmação de chegada(ATA)],
dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,5) [Numero da DI],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,5) [Data do registro da DI],
TP4.Dt_Conclusao [Data do desembaraço],
HOU.Canal [Canal],
TP108.Dt_Conclusao [Recebimento da Danfe],
TP7.Dt_Conclusao [Data entrega dos documentos para transporte],
--dbo.fBusca_HistoricoDescr_Completo(hou.Num_Proc) [Historico],
--dbo.fBusca_HistoricoDescr_Tipo_S_Completo(hou.Num_Proc) [Historico],
dbo.fBusca_HistoricoDescr(hou.Num_Proc,116,NULL),

HOU.Original_ETA [Delivery Date Planta do PO(ETA original)],
isnull(V36.Descricao,'NÃO') [Urgente],
UR.Nome_Usuario [Responsavel pelo Pedido],
POrg.Nome_Pais [Country],
ROrg.Nome_Regiao [Region],
CONVERT(datetime,getdate(),103) [Data Base],
NULL [Embarque em atraso?],
NULL [Chegada em atraso?],
NULL [Situação]
from vwHouse_Imp HOU with(nolock)
left Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
left join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
left join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
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
left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP50.ID_Task =40
left join Usuario_Cliente UR with(nolock) on PP.cd_CSRID = UR.Cd_Usuario
join Localidade ORG with(nolock) on HOU.Cd_Org = ORG.Cd_Local
left join Pais POrg with(nolock) on ORG.Cd_Pais = POrg.cd_pais
left join Regiao ROrg with(nolock) on ROrg.cd_regiao = ORG.cd_regiao
left join Campo_Processo CP143 with(nolock) on HOU.Num_Proc = CP143.Num_Proc and CP143.Id_Campo = 143

where 
	HOU.ID_Status not in(9,7,8)
	and CP143.Campo_Dados in (1,3) 
	and TP40.Dt_Conclusao is null 
	and (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	and convert(datetime,HOU.dt_emis,103) between @DtInicial and @DtFinal

option(hash join)

/*
select * from REgiao
select * from Tipo_Tarefas where Nome_Task like '%Envio%'
select * from Tipo_Doc_Cliente where Nome_DC like '%BDP%'
select * from tipo_campo_cliente where Descr_campo like '%BDP%'
select top 10 * from Pedido
select top 100 * from vwPedidoShipxPedido order by dt_pedido desc
*/
/*
where HOU.Num_Proc in ('IMSOL201810063BR',
'IMSOL201811036BR',
'IMSOL201811165BR',
'IMSOL201809005BR', 
'IMSOL201812009BR',
'IMSOL201901030BR',
'IMSOL201812049BR')
*/
 --Embarque em atraso?
update @Temp set 
[Embarque em atraso?] = 
DATEDIFF(DAY,  [Data Base],[Delivery Date Planta do PO(ETA original)]) 
where SUBSTRING([BDP Ref.],2,1) = 'M' and [Recebimento do booking] is  null

--Chegada em atraso?
	--Ocean
	update @Temp set 
	[Chegada em atraso?] =  
	(Case when [Confirmação de chegada(ATA)]  is not null 
	then DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) 
	else DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)])end) 
	where SUBSTRING([BDP Ref.],2,1) = 'M' and  [Recebimento do booking] is not null
	--Not Ocean
	update @Temp set 
	[Chegada em atraso?] =  
	(Case when [Confirmação de chegada(ATA)]  is not null 
	then DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) 
	else DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)])end) 
	where SUBSTRING([BDP Ref.],2,1) <> 'M' 

--Situação
	--Ocean
	update @Temp set 
	[Situação] =  
	(Case when [Confirmação de chegada(ATA)]  is not null 
		  then 
			(Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) >= 6 
				  Then 'ANTECIPADO - Chegada Confirmada'
			 else	  
				'ATRASADO - Chegada Confirmada'
			 End)
	else 
		
		(Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)]) >= 6
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
			(Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) >= 6 
				  Then 'ANTECIPADO - Chegada Confirmada'
			 else	  
				'ATRASADO - Chegada Confirmada'
			 End)
	else 
		
		(Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)]) >= 6
			  Then 'ANTECIPADO - Em Trânsito ou com Dados de Embarque' 
		 else
			'ATRASADO - Em Trânsito ou com Dados de Embarque'
		 End)
	end)  
	where SUBSTRING([BDP Ref.],2,1) <> 'M' 
	
	update @Temp set 
		[Situação] = 
		(Case when  [Region] = 'Asia' Then
			(Case when DATEDIFF(DAY,  [Data Base],[Delivery Date Planta do PO(ETA original)]) < 55
				  Then 'ATRASADO - Sem Dados de Embarque' 
				 else
					'OK - Sem Dados de Embarque'
				 End)
		  else
		  	(Case when DATEDIFF(DAY,  [Data Base],[Delivery Date Planta do PO(ETA original)]) < 40
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
			(Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) between -5 and 5 
				  Then 'OK - Chegada Confirmada'
			else
			[Situação]
			 End)
	else 
		
		(Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)]) between -5 and 5 
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
			(Case when DATEDIFF(DAY,  [Confirmação de chegada(ATA)],[Delivery Date Planta do PO(ETA original)]) between -5 and 5 
				  Then 'OK - Chegada Confirmada'
			else
			[Situação]
			 End)
	else 
		
		(Case when DATEDIFF(DAY,  [Previsão de chegada(ETA)],[Delivery Date Planta do PO(ETA original)]) between -5 and 5 
			  Then 'OK - Em Transito ou com Dados de Embarque' 
			  else
			  [Situação]
		 End)
	end) 
	where SUBSTRING([BDP Ref.],2,1) <> 'M'


select * from @Temp






GO
