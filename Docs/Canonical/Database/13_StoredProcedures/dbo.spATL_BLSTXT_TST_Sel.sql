SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_BLSTXTNew_Sel] 'DA2012120225',''
--[spATL_BLSTXTNew_Sel] '2','DA2012120225',''
--[spATL_BLSTXTNew_Sel] '3','DA2012120225','D'
--[spATL_BLSTXT_TST_Sel] '','2013-04-01','2013-04-05'

CREATE procedure [dbo].[spATL_BLSTXT_TST_Sel] 
	@JOB varchar(16),
	@DataInicial datetime,
	@DataFinal datetime
	
AS

--Declare @NumLctoDiv varchar(12)
--BEGIN TRANSACTION
SET NOCOUNT ON
		Declare @TAB Table --1
				(
					[Num_Lcto_Div] varchar(12),
					[Tipo de Registro] int,
					[Tipo de Lancamento] varchar(2),
					[Conta Reduzida] varchar(7), 
					[Codigo Centro de Custo] varchar(42),
					[Natureza Sub Lancamento] varchar(1),
					[Data]	varchar(4),
					[Valor] varchar(17),
					[Historico Padrao] varchar(200),
					[Complemento] varchar(200)
					)
		Declare @TAB1 Table --1
				(
					[Num_Lcto_Div] varchar(12),
					[Tipo de Registro] int,
					[Tipo de Lancamento] varchar(2),
					[Conta Reduzida] varchar(7), 
					[Codigo Centro de Custo] varchar(42),
					[Natureza Sub Lancamento] varchar(1),
					[Data]	varchar(4),
					[Valor] varchar(17),
					[Historico Padrao] varchar(200),
					[Complemento] varchar(200)
					)
	Declare @NumLctoDiv	varchar(12)
	Declare @DC_Item Varchar(1)
	Declare @Num_Lcto_Div Varchar(12)
	Declare	@Cd_Cta_Ctb_Red varchar(7)
--Declare C_NumLctoDiv cursor for
--Busca DAs conforme datas informadas.

	if @JOB <> '' and @JOB is not NULL
		Begin
			Declare C_NumLctoDiv cursor for
			Select Num_lcto_div from Pgto_Rcto_Div with(nolock) where Num_Lcto_Div = @JOB
			--print 1
		End
	else
		Begin
			Declare C_NumLctoDiv cursor for
			Select Num_lcto_div from Pgto_Rcto_Div with(nolock) where convert(datetime,Dt_Pgto_Rcto_Div,105) between @DataInicial and @DataFinal --and (forma_pgto_rcto_div not like 'transf.' and dc_div <> 'C')
			--print 2
		End

--	Select Num_lcto_div from Pgto_Rcto_Div with(nolock) where convert(datetime,Dt_Pgto_Rcto_Div,105) between @DataInicial and @DataFinal

Open C_NumLctoDiv
--SET NOCOUNT ON
Fetch Next From C_NumLctoDiv Into @NumLctoDiv

		While @@FETCH_STATUS = 0
			Begin
--Insere Cabecalho (1) 
				Insert into @TAB
					select 
						PG.Num_Lcto_Div [Num_Lcto_Div],
						1 [Tipo de Registro],
						'MM' [Tipo de Lancamento],
						NULL [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						NULL [Natureza Sub Lancamento],
						substring(replace(Dt_Pgto_Rcto_Div,'/',''),1,4) [Data],
						sum(Vlr_ITem) [Valor],
						NULL [Historico Padrao],
						--'00000' [Historico Padrao],
						NULL [Complemento]
						--@NumLctoDiv[Complemento]
					from Pgto_Rcto_Div PG with(nolock)
					Join Pgto_Rcto_Div_DET item on Item.num_lcto_Div=PG.num_lcto_div and ITem.dc_item=PG.dc_div
					where PG.Num_Lcto_Div = @NumLctoDiv
					Group by PG.num_lcto_Div,Dt_Pgto_Rcto_Div
--Monta Registro Tipo 2 - Detalhes
				delete @TAB1
				Insert into @TAB1
					select 
						PR.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						CB.Cd_Cta_Ctb_Red [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						PRD.DC_Item [Natureza Sub Lancamento],
						NULL [Data],
						sum(PRD.Vlr_Item) [Valor],
						'00074' [Historico Padrao],
						PR.num_Lcto_Div + '-' + UPPER(max(PRD.Compl_Hist)) [Complemento]
					from Pgto_Rcto_Div_Det PRD with(nolock)
						join Pgto_Rcto_Div PR with(nolock) on PRD.Num_Lcto_Div = PR.Num_Lcto_Div
						join Cta_Ctb CB with(nolock) on PRD.Cd_Cta_Ctb = CB.Cd_Cta_Ctb
					where PR.Num_Lcto_Div = @NumLctoDiv --and PRD.DC_Div = 'D'
					group by PR.Num_Lcto_Div,CB.Cd_Cta_Ctb_Red,PRD.DC_Item 

	Declare Cur_TAB1 cursor for
--Carrega campos chaves para buscar registro tipo 3 (Detalhes do registro 2)
			Select [Num_Lcto_Div],[Natureza Sub Lancamento],[Conta Reduzida] from @TAB1
	Open Cur_TAB1
		Fetch Next From Cur_TAB1 Into @Num_Lcto_Div, @DC_Item, @Cd_Cta_Ctb_Red
		
			While @@FETCH_STATUS = 0
				Begin	
--Insere Registro Tipo 2 - Detalhes
					Insert into @TAB
						Select * from @TAB1 where [Num_Lcto_Div] = @Num_Lcto_Div and [Natureza Sub Lancamento] = @DC_Item and [Conta Reduzida]= @Cd_Cta_Ctb_Red
--Insere REgistro Tipo 3 - Detalhes do registro Tipo 3					
					Insert into @TAB
						select 
							Num_Lcto_Div [Num_Lcto_Div],
							3 [Tipo de Registro],
							NULL [Tipo de Lancamento],
							NULL [Conta Reduzida],
							Cd_Centro_Custo [Codigo Centro de Custo],
							NULL [Natureza Sub Lancamento],
							NULL [Data],
							Vlr_Item [Valor],
							NULL [Historico Padrao],
							NULL [Complemento]
						from Pgto_Rcto_Div_Det PRD with(nolock)
						join Cta_Ctb CB with(nolock) on PRD.Cd_Cta_Ctb = CB.Cd_Cta_Ctb and CB.Cd_cta_ctb_red = @Cd_Cta_Ctb_Red
						where Num_Lcto_Div = @Num_Lcto_Div and DC_Item = @DC_Item and Cd_Cta_Ctb_Red = @Cd_Cta_Ctb_Red
					Fetch Next From Cur_TAB1 Into @Num_Lcto_Div, @DC_Item, @Cd_Cta_Ctb_Red
				end
			close Cur_TAB1
			deallocate Cur_TAB1 
--Insere Registro Tipo 2 - Banco
				Insert into @TAB
					select 
						PR.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						CB.Cd_Cta_Ctb_Red [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						Case WHEN PR.Dc_Div = 'C' THEN 'D' ELSE 'C' END [Natureza Sub Lancamento],
						NULL [Data],
						PR.Vlr_Doc_Div [Valor],
						'00074' [Historico Padrao],
						PR.num_Lcto_Div + '-' + UPPER(max(PRD.Compl_Hist))[Complemento]
--						NULL [Complemento]
					from Pgto_Rcto_Div PR with(nolock)
						--incluido o det pra trazer o historico
						join Pgto_Rcto_Div_Det PRD with(nolock) on PR.Num_Lcto_Div = PRD.Num_Lcto_Div
						join Cta_Cte CC with(nolock) on PR.Cd_Banco = CC.Cd_Banco and PR.Cd_Agencia = CC.Cd_Agencia and PR.Num_Cta_Cte = CC.Num_Cta_Cte
						join Cta_Ctb CB with(nolock) on CC.Cd_Cta_Ctb = CB.Cd_Cta_Ctb
					where PR.Num_Lcto_Div = @NumLctoDiv --and PRD.DC_Div = 'D'
					--incluido o group by 
					group by PR.Num_Lcto_Div,CB.Cd_Cta_Ctb_Red,PR.DC_Div,PR.Vlr_Doc_Div
			Fetch Next From C_NumLctoDiv Into @NumLctoDiv
		End
	close C_NumLctoDiv
	deallocate C_NumLctoDiv 
--Ajuste de Campos
			update
				@TAB
				Set
					[Conta Reduzida] = replace(str([Conta Reduzida],7),' ','0')
					--[Valor] = dbo.PreencheString(replace(str([Valor],12,2),'.',','),17,'0')
			where
				[Tipo de Registro] = 2
			update
				@TAB
				Set
					[Codigo Centro de Custo] = dbo.PreencheString(right([Codigo Centro de Custo],2),42,' ')
					--[Valor] = replace(str([Valor],12,2),'.',',')
			where
				[Tipo de Registro] = 3
				
			update
				@TAB
				Set 
				[Valor] = dbo.PreencheString(replace(convert(decimal(10,2),[Valor]),'.',','),17,'0')
--Resultado				
select * from @TAB

--IF @@ERROR <> 0 
--		BEGIN
--			ROLLBACK TRANSACTION
--			return -1
--		END
--COMMIT TRANSACTION	




GO
