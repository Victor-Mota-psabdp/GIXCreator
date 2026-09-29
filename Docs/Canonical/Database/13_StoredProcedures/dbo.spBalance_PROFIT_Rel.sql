SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spBALANCE REPORT_PROFIT_JOB_Rel]'EORHO201605004BR'
--select * from vwcta_Cte where Num_Proc_HIA = 'EORHO201605004BR'

CREATE procedure [dbo].[spBalance_PROFIT_Rel]--2016,6,'Last Month'
(
	--@Dt_Inicial as Datetime,
	--@Dt_Final as Datetime	
	@Ano int,
	@Mes int,
	@Tipo varchar(10)
)
AS

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

--declare @Ano as int
--declare	@Mes as int
--declare @Tipo varchar(10)

--set @Ano =2016
--set @Mes = 5

If @Tipo = 'Last Month' 
	Begin
		Set @Mes= (select month(getdate()) -1)		
	End

IF @Ano = 0
begin
	set @Ano = (select YEAR(getdate()))
end


Declare @JOB as Varchar(16)
Declare @BDP_Produto as Varchar(50)
Declare @Master as Varchar(14)
Declare @Shipper as Varchar(20)
Declare @Consignee as Varchar(20)
Declare @CNPJ	varchar(20)
Declare @BDP_Grupo as Varchar(20)
Declare @Status as Varchar(250)

Declare  @TAB Table
	(		
		[Num_proc]	varchar(16),
		[Nome_BDP_Produto]	varchar(50),
		[Master]	varchar(14),
		[Shipper]	varchar(20),
		[consignee]	varchar(20),
		[Num_CNPJ]	varchar(20),
		[BDPGrupo]	varchar(20),
		[Status]	varchar(250)
	)
	
insert into @TAB
	select V.num_proc, Nome_BDP_Produto, V.Master, PS.Nome_Raz_Soc, PC.Nome_Raz_Soc,PS.Num_CPF_CNPJ,PG.Apelido ,cast(V.Id_status as varchar(10))+ ' - ' + T.Status_Descricao from vwClienteALLJOBS V with(nolock)
	left join Tipo_Status_Processo T with(nolock) on T.ID_Status = V.ID_Status
	left join Pessoa PC			with(nolock) on V.cd_fornecedor = PC.Cd_Pes
	left join Pessoa PS			with(nolock) on V.cd_cliente = PS.Cd_Pes
	Left Join Pessoa_LLP PLL	with(nolock) on PS.Cd_Pes = PLL.Cd_Pes
	Left Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
	Left Join pessoa PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
	left join Campo_Processo CP with(nolock) on V.num_proc = CP.Num_Proc and CP.Id_Campo = 143
	left join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
	where 
		year(convert(datetime,Dt_Criacao,103)) = @Ano
		and (month(convert(datetime,Dt_Criacao,103))= @Mes)-- or @Mes='')
		--and V.num_Proc = 'EMAMZ201606001BR'
	
Declare @TempNF Table
	(		
		JOB						varchar(50),
		BDP_Produto				varchar(50),
		Master					varchar(14),
		Shipper					varchar(20),
		Consignee 				varchar(20),
		CNPJ					varchar(20),
		BDP_Grupo				varchar(20),
		[Nome_Taxa]				varchar(200),
		[D/C]					varchar(2),
		[Currency]				varchar(6),
		--[Caixa]					varchar(200),		
		[1 - Sales]				float,
		[1 - Sales_Original]	float,
		[2 - Sales Tax]			float,
		[3 - Cost]				float,
		[(G) / P]				float,	
		[4 - Advance]			float,
		[5 - PT Cost]			float,	
		[6 - PT Revenue]		float,
		[Balance]				float,
		[Status]				varchar(250)
	)
	
Declare @TAB1 Table
	(		
		JOB						varchar(50),
		BDP_Produto				varchar(50),
		Master					varchar(14),
		Shipper					varchar(20),
		Consignee 				varchar(20),
		CNPJ					varchar(20),
		BDP_Grupo				varchar(20),
		[Nome_Taxa]				varchar(200),
		[D/C]					varchar(2),
		[Currency]				varchar(6),
		--[Caixa]					varchar(200),	
		[1 - Sales]				float,
		[1 - Sales_Original]	float,
		[2 - Sales Tax]			float,
		[3 - Cost]				float,
		[(G) / P]				float,	
		[4 - Advance]			float,
		[5 - PT Cost]			float,
		[6 - PT Revenue]		float,	
		[Balance]				float,
		[Status]				varchar(250)
	)

	
Declare C_JOBs cursor for
		Select [Num_proc],[Nome_BDP_Produto],[Master],[Shipper],[Consignee],[Num_CNPJ],[BDPGrupo],[Status] from @TAB	
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @JOB,@BDP_Produto,@Master,@Shipper,@Consignee,@CNPJ,@BDP_Grupo,@Status

	While @@FETCH_STATUS = 0
		Begin
			delete @TempNF
			insert into @TempNF
				([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[1 - Sales])
			exec spATL_BuscaConferenciaJOB_Sel @JOB,'ResultadoR'
			
			insert into @TempNF
				([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[3 - Cost])
			exec spATL_BuscaConferenciaJOB_Sel @JOB,'ResultadoC'			

			insert into @TempNF
				([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[5 - PT Cost])
			exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaC'
			
			insert into @TempNF
				([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[6 - PT Revenue])
			exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaR'

			update @TempNF set
			[JOB] = @JOB,
			--[Status] = @Status,
			[2 - Sales Tax]	= [dbo].[fBusca_CalculaImposto](@JOB,[Nome_Taxa],[D/C],ISNULL([1 - Sales],0)) * -1

			update @TempNF set 
			[Balance]=ISNULL([4 - Advance],0) + ISNULL([5 - PT Cost],0) + ISNULL([6 - PT Revenue],0),
			[(G) / P]=ISNULL([1 - Sales],0) + ISNULL([2 - Sales Tax],0) + ISNULL([3 - Cost],0)
						
			insert into @TempNF	
				select 'Total ' + @JOB,@BDP_Produto,@Master,@Shipper,@Consignee,@CNPJ,@BDP_Grupo,'','','',
					SUM([1 - Sales])						[1 - Sales], 
					SUM([1 - Sales_Original])				[1 - Sales_Original], 
					SUM([2 - Sales Tax])					[2 - Sales Tax],		
					SUM([3 - Cost])							[3 - Cost],
					sum([(G) / P])							[(G) / P], 
					SUM([4 - Advance])						[4 - Advance],
					sum([5 - PT Cost])						[5 - PT Cost],
					sum([6 - PT Revenue])					[6 - PT Revenue],		
					SUM([Balance])							[Balance],@Status	
				from @TempNF
				where [Nome_Taxa] is not null
				--group by [Status]		
					
			
			insert into @TAB1
				select [JOB], [BDP_Produto],[Master],[Shipper],[Consignee],[CNPJ],[BDP_Grupo],[Nome_Taxa],[D/C],[Currency],
				[1 - Sales],[1 - Sales_Original],[2 - Sales Tax],[3 - Cost],[(G) / P],
				[4 - Advance],[5 - PT Cost],[6 - PT Revenue],[Balance],[Status]
				from @TempNF
	
									
Fetch Next From C_JOBS Into @JOB,@BDP_Produto,@Master,@Shipper,@Consignee,@CNPJ,@BDP_Grupo,@Status

		End
	
close C_JOBS
deallocate C_JOBS

select 
	[JOB], [BDP_Produto] [BDP Product], [Master] [Consol Ref.], Shipper, Consignee, [CNPJ] CNPJ,BDP_Grupo [Group Name],[JOB] + ' - ' + [Nome_Taxa] [Descrição],[1 - Sales],[2 - Sales Tax],[3 - Cost],[(G) / P],
	[4 - Advance],[5 - PT Cost],[6 - PT Revenue],[Balance],[D/C],[Currency],[Status]
from 
	--@TempNF 
	@TAB1 
Where
	[(G) / P] is not null
--order by 
--	JOB,Nome_Taxa







GO
