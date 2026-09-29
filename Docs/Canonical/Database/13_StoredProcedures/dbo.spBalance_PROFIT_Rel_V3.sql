SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_BuscaConferenciaJOB_Sel 'EORHO201608037BR','ResultadoR'
--spATL_BuscaConferenciaJOB_Sel 'EORHO201608037BR','ResultadoC'			
--spATL_BuscaConferenciaJOB_Sel 'EORHO201608037BR','ReceitaC'
--spATL_BuscaConferenciaJOB_Sel 'EORHO201608037BR','ReceitaR'


--Cadu-24/11/2016 - retirei o and do join: join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX --and I.Account_Number = TA.CC_Receita
--EORHO201608037BR - Serviços de Despacho 1 - DESPACHO - R$ 203,57
CREATE procedure [dbo].[spBalance_PROFIT_Rel_V3]--'GRUPO RHODIA','2016-08-17','2016-08-17'
(
	@Grupo varchar(50),
	--@CNPJ varchar(50),
	@Dt_Inicial as Datetime,
	@Dt_Final as Datetime	
)
AS

--Declare @Dt_Inicial as Datetime
--Declare @Dt_Final as Datetime

--set @Dt_Inicial = GETDATE() - 180
--set @Dt_Final = GETDATE()	

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

Declare @TempNF Table
	(		
		[JOB]						varchar(50),
		[BDP_Produto]				varchar(50),
		[Master]					varchar(14),
		[Shipper]					varchar(200),
		[Consignee] 				varchar(200),
		[CNPJ]						varchar(20),
		[BDP_Grupo]					varchar(20),
		[Status]					varchar(250),
		[Nome_Taxa]					varchar(200),
		[D/C]						varchar(2),
		[Currency]					varchar(6),
		[1 - Sales_Original]		float,				
		[1 - Sales]					float,		
		[2 - Sales Tax]				float,
		[3 - Cost]					float,
		[(G) / P]					float,	
		[4 - PT Cost]				float,	
		[5 - Advance/PT Revenue]	float,
		[Balance]					float
		
	)

	Insert into @TempNF
	--ResultadoR'
		select 
			V.num_proc,Nome_BDP_Produto,V.Master, PS.Nome_Raz_Soc,PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,PG.Apelido,cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao,
			TX.Nome_Tp_Tx [Nome_Taxa],I.DC[D/C],I.Moeda [Currency], 
			dbo.valor(I.Valor,I.DC) [1 - Sales_Original],
			--'ResultadoR' = [Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[1 - Sales]
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [1 - Sales],				
			[dbo].[fBusca_CalculaImposto](V.num_proc,TX.Nome_Tp_Tx,I.DC,ISNULL(CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)),0)) * -1 [2 - Sales Tax]					
			,NULL [3 - Cost],NULL[(G) / P],	NULL[4 - PT Cost],NULL[5 - Advance/PT Revenue],	NULL[Balance]
		from vwClienteALLJOBS V with(nolock)
			left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
			left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
			left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
			Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
			Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
			left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
			left join AX_Doc_Item I		with(nolock) on V.num_proc = I.Num_Proc
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and (I.Account_Number = TA.CC_Receita or I.Account_Number = '3.1.1.001.049')
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx			
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			(PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
			--and (REPLACE(REPLACE(right(PS.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
			and (convert(Datetime,Dt_Criacao,105) between @Dt_Inicial and @Dt_Final) 
			and V.ID_Status = '8'
			and  DocumentNum is not  NULL
			
	UNION ALL
		--ResultadoC
		select 
			V.num_proc,Nome_BDP_Produto,V.Master, PS.Nome_Raz_Soc,PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,PG.Apelido,cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao,
			TX.Nome_Tp_Tx [Nome_Taxa],I.DC[D/C],I.Moeda [Currency], 
			dbo.valor(I.Valor,I.DC) [1 - Sales_Original],
			NULL [1 - Sales],NULL [2 - Sales Tax],
			--'ResultadoC' = [Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[3 - Cost]
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC))[3 - Cost],
			NULL[(G) / P],	NULL[4 - PT Cost],NULL[5 - Advance/PT Revenue],	NULL[Balance]
		from vwClienteALLJOBS V with(nolock)
			left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
			left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
			left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
			Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
			Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
			left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
			left join AX_Doc_Item I		with(nolock) on V.num_proc = I.Num_Proc
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx			
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			(PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
			--and (REPLACE(REPLACE(right(PS.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
			and (convert(Datetime,Dt_Criacao,105) between @Dt_Inicial and @Dt_Final)  
			and V.ID_Status = '8'
			and  DocumentNum is not  NULL
			
	UNION ALL
		--ReceitaC
		select 
			V.num_proc,Nome_BDP_Produto,V.Master, PS.Nome_Raz_Soc,PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,PG.Apelido,cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao,
			TX.Nome_Tp_Tx [Nome_Taxa],I.DC[D/C],I.Moeda [Currency], 
			dbo.valor(I.Valor,I.DC) [1 - Sales_Original],
			NULL [1 - Sales],NULL [2 - Sales Tax],NULL[3 - Cost],NULL[(G) / P],	
			--'ReceitaC' = [Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[4 - PT Cost]
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [4 - PT Cost],
			NULL[5 - Advance/PT Revenue],NULL[Balance]
		from vwClienteALLJOBS V with(nolock)
			left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
			left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
			left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
			Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
			Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
			left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
			left join AX_Doc_Item I		with(nolock) on V.num_proc = I.Num_Proc
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx			
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			(PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
			--and (REPLACE(REPLACE(right(PS.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
			and (convert(Datetime,Dt_Criacao,105) between @Dt_Inicial and @Dt_Final) 
			and V.ID_Status = '8'
			and  DocumentNum is NULL
			and I.Cd_Tp_TX <> '900.1'	
			
	UNION ALL
		--ReceitaR
		select 
			V.num_proc,Nome_BDP_Produto,V.Master, PS.Nome_Raz_Soc,PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,PG.Apelido,cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao,
			TX.Nome_Tp_Tx [Nome_Taxa],I.DC[D/C],I.Moeda [Currency], 
			dbo.valor(I.Valor,I.DC) [1 - Sales_Original],
			NULL [1 - Sales],NULL [2 - Sales Tax],NULL[3 - Cost],NULL[(G) / P],NULL [4 - PT Cost],
			--'ReceitaR' = [Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[5 - Advance/PT Revenue]
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [5 - Advance/PT Revenue],
			NULL [Balance]
		from vwClienteALLJOBS V with(nolock)
			left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
			left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
			left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
			Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
			Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
			left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
			left join AX_Doc_Item I		with(nolock) on V.num_proc = I.Num_Proc
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX 
						and (I.Account_Number = TA.CC_Receita  or I.Cd_Tp_TX = '900.1')
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx			
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			(PG.Apelido = @Grupo or @Grupo ='Grupo ALL') 
			--and (REPLACE(REPLACE(right(PS.Num_CPF_CNPJ,14),'/',''),'-','') = @CNPJ or @CNPJ='')
			and (convert(Datetime,Dt_Criacao,105) between @Dt_Inicial and @Dt_Final)  
			and V.ID_Status = '8'
			and DocumentNum is  NULL
		
	--select * from @TempNF
	BEGIN
	update @TempNF set 
		[Balance]= ISNULL([4 - PT Cost],0) + ISNULL([5 - Advance/PT Revenue],0),
		[(G) / P]=ISNULL([1 - Sales],0) + ISNULL([2 - Sales Tax],0) + ISNULL([3 - Cost],0)
	END	
	
	BEGIN					
		insert into @TempNF		
			select [JOB],[BDP_Produto],[Master],[Shipper],[Consignee],[CNPJ],[BDP_Grupo],[Status],'','','',			
				SUM([1 - Sales_Original])				[1 - Sales_Original], 
				SUM([1 - Sales])						[1 - Sales], 
				SUM([2 - Sales Tax])					[2 - Sales Tax],		
				SUM([3 - Cost])							[3 - Cost],
				sum([(G) / P])							[(G) / P], 
				sum([4 - PT Cost])						[4 - PT Cost],
				sum([5 - Advance/PT Revenue])			[5 - PT Revenue],		
				SUM([Balance])							[Balance]	
			from @TempNF
			where [Nome_Taxa] is not null
			group by [JOB],[BDP_Produto],[Master],[Shipper],[Consignee],[CNPJ],[BDP_Grupo],[Status]	
	END
	
	
Declare @TAB1 Table
	(		
		JOB						varchar(50),
		BDP_Produto				varchar(50),
		Master					varchar(14),
		Shipper					varchar(200),
		Consignee 				varchar(200),
		CNPJ					varchar(20),
		BDP_Grupo				varchar(20),
		[Nome_Taxa]				varchar(200),
		[D/C]					varchar(2),
		[Currency]				varchar(6),		
		[1 - Sales]				float,
		[1 - Sales_Original]	float,
		[2 - Sales Tax]			float,
		[3 - Cost]				float,
		[(G) / P]				float,	
		[4 - PT Cost]			float,	
		[5 - Advance/PT Revenue]float,	
		[Balance]				float,
		[Status]				varchar(250),
		[Descricao]				varchar(500)
	)
	
Declare @JOB as Varchar(16)


Declare C_JOBs cursor for
		Select distinct [JOB] from @TempNF	
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @JOB

	While @@FETCH_STATUS = 0
		Begin
			insert into @TAB1
				select [JOB], [BDP_Produto],[Master],[Shipper],[Consignee],[CNPJ],[BDP_Grupo],[Nome_Taxa],[D/C],[Currency],
				[1 - Sales],[1 - Sales_Original],[2 - Sales Tax],[3 - Cost],[(G) / P],
				[4 - PT Cost],[5 - Advance/PT Revenue],[Balance],[Status],[JOB] + ' - ' + [Nome_Taxa]
				from @TempNF
				where [JOB]= @JOB

Fetch Next From C_JOBS Into @JOB

		End
	
close C_JOBS
deallocate C_JOBS
	
	BEGIN
		update @TAB1 set [JOB] = 'Total ' + [JOB]
		where [Nome_Taxa] = ''
	END
	
select 
	[JOB], [BDP_Produto] [BDP Product], [Master] [Consol Ref.], Shipper, Consignee, [CNPJ] CNPJ,BDP_Grupo [Group Name],[Descricao],[1 - Sales],[2 - Sales Tax],[3 - Cost],[(G) / P],
	[4 - PT Cost],[5 - Advance/PT Revenue],[Balance],[D/C],[Currency],[Status]
from 
	@TAB1 
Where
	[(G) / P] is not null
GO
