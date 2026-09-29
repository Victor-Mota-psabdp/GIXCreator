SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_BLSTXT_Sel] '2012-04-01','2012-04-30'

create procedure [dbo].[spATL_BLSTXTNEW_Sel] --'2012-04-01','2012-04-30'

	@DataInicial datetime,
	@DataFinal	datetime


AS


Declare @NumLctoDiv varchar(12)
Declare @iLancamento int
Set @iLancamento = 0
Declare @TAB Table
		(
			[Lancamento] int,
			[Num_Lcto_Div] varchar(12),
			[Data] varchar(5),
			[Debito] varchar(10),
			[Credito] varchar(10),
			[Valor] float,
			[Historico Padrao] varchar(200),
			[Complemento] varchar(200),
			[CCDB] varchar(10),
			[CCCR] varchar(10)
			)
			
Declare C_NumLctoDiv cursor for

	Select Num_lcto_div from Pgto_Rcto_Div where convert(datetime,Dt_Pgto_Rcto_Div,105) between @DataInicial and @DataFinal

Open C_NumLctoDiv
SET NOCOUNT ON
Fetch Next From C_NumLctoDiv Into @NumLctoDiv

		While @@FETCH_STATUS = 0
			Begin
				Set @iLancamento = @iLancamento + 1
			insert into @Tab
				select 
				@iLancamento [Lancamento],
				PR.Num_Lcto_Div,
				substring(Dt_Pgto_Rcto_Div,1,5) [Data],
				'M' [Debito],
				'M' [Credito],
				PR.Vlr_Doc_Div [Valor],
				NULL [Historico Padrao],
				NULL [Complemento],
				--PRD.Compl_Hist [Complemento],
				NULL [CCDB],
				NULL [CCCR]
				--(Case WHEN PR.Dc_Div = 'C' THEN PRD.Cd_Centro_Custo END) [CCDB],
				--(Case WHEN PR.Dc_Div = 'D' THEN PRD.Cd_Centro_Custo END) [CCCR]
				--CB.Cd_Cta_Ctb_Red [Cta_Ctb], 
				--PR.Dc_Div, 
				--CBD.Cd_Cta_Ctb_Red [Cta_Ctb_Item], 
				--PRD.DC_Item,  
				--PRD.Vlr_Item, 
				--PRD.Compl_Hist,
				--[Resgistros D] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'D'),
				--[Resgistros C] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'C')
				from
				Pgto_Rcto_Div PR
					--join Pgto_Rcto_Div_Det PRD on PR.Num_Lcto_Div = PRD.Num_Lcto_Div
					--join Cta_Cte CC on PR.Cd_Banco = CC.Cd_Banco and PR.Cd_Agencia = CC.Cd_Agencia and PR.Num_Cta_Cte = CC.Num_Cta_Cte
					--join Cta_Ctb CB on CC.Cd_Cta_Ctb = CB.Cd_Cta_Ctb
					--join Cta_Ctb CBD on PRD.Cd_Cta_Ctb = CBD.Cd_Cta_Ctb
				where 
				PR.Num_Lcto_Div = @NumLctoDiv

	insert into @Tab

				select 
				@iLancamento [Lancamento],
				PR.Num_Lcto_Div,
				substring(Dt_Pgto_Rcto_Div,1,5) [Data],
				isnull((Case WHEN PR.Dc_Div = 'C' THEN CB.Cd_Cta_Ctb_Red END),'T') [Debito],
				isnull((Case WHEN PR.Dc_Div = 'D' THEN CB.Cd_Cta_Ctb_Red END),'T') [Credito],
				PR.Vlr_Doc_Div [Valor],
				NULL [Historico Padrao],
				NULL [Complemento],
				--PRD.Compl_Hist [Complemento],
				NULL [CCDB],
				NULL [CCCR]
				--(Case WHEN PR.Dc_Div = 'C' THEN PRD.Cd_Centro_Custo END) [CCDB],
				--(Case WHEN PR.Dc_Div = 'D' THEN PRD.Cd_Centro_Custo END) [CCCR]
				--CB.Cd_Cta_Ctb_Red [Cta_Ctb], 
				--PR.Dc_Div, 
				--CBD.Cd_Cta_Ctb_Red [Cta_Ctb_Item], 
				--PRD.DC_Item,  
				--PRD.Vlr_Item, 
				--PRD.Compl_Hist,
				--[Resgistros D] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'D'),
				--[Resgistros C] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'C')
				from
				Pgto_Rcto_Div PR
					--join Pgto_Rcto_Div_Det PRD on PR.Num_Lcto_Div = PRD.Num_Lcto_Div
					join Cta_Cte CC on PR.Cd_Banco = CC.Cd_Banco and PR.Cd_Agencia = CC.Cd_Agencia and PR.Num_Cta_Cte = CC.Num_Cta_Cte
					join Cta_Ctb CB on CC.Cd_Cta_Ctb = CB.Cd_Cta_Ctb
					--join Cta_Ctb CBD on PRD.Cd_Cta_Ctb = CBD.Cd_Cta_Ctb
				where 
				PR.Num_Lcto_Div = @NumLctoDiv

insert into @Tab

				select 
				@iLancamento [Lancamento],
				PR.Num_Lcto_Div,
				substring(Dt_Pgto_Rcto_Div,1,5) [Data],
				isnull((Case WHEN PRD.Dc_Item = 'C' THEN CBD.Cd_Cta_Ctb_Red END),'T') [Debito],
				isnull((Case WHEN PRD.Dc_Item = 'D' THEN CBD.Cd_Cta_Ctb_Red END),'T') [Credito],
				PRD.Vlr_Item [Valor],
				--NULL [Historico Padrao],
				NULL [Complemento],
				PRD.Compl_Hist [Complemento],
				--NULL [CCDB],
				--NULL [CCCR]
				(Case WHEN PR.Dc_Div = 'C' THEN PRD.Cd_Centro_Custo END) [CCDB],
				(Case WHEN PR.Dc_Div = 'D' THEN PRD.Cd_Centro_Custo END) [CCCR]
				--CB.Cd_Cta_Ctb_Red [Cta_Ctb], 
				--PR.Dc_Div, 
				--CBD.Cd_Cta_Ctb_Red [Cta_Ctb_Item], 
				--PRD.DC_Item,  
				--PRD.Vlr_Item, 
				--PRD.Compl_Hist,
				--[Resgistros D] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'D'),
				--[Resgistros C] =(select count(Num_Lcto_Div) from Pgto_Rcto_Div_Det where Num_Lcto_Div = PR.Num_Lcto_Div and Dc_Item = 'C')
				from Pgto_Rcto_Div PR
					join Pgto_Rcto_Div_Det PRD on PR.Num_Lcto_Div = PRD.Num_Lcto_Div
					join Cta_Ctb CBD on PRD.Cd_Cta_Ctb = CBD.Cd_Cta_Ctb
				where 
				PR.Num_Lcto_Div = @NumLctoDiv
			Fetch Next From C_NumLctoDiv Into @NumLctoDiv
		End
	close C_NumLctoDiv
	deallocate C_NumLctoDiv 

	Select 	
			dbo.PreencheString([Lancamento],7,'0') [Lancamento],
			[Data],
			(Case [Debito]
				WHEN 'M' THEN dbo.PreencheString([Debito],7,' ')
				WHEN 'T' THEN dbo.PreencheString([Debito],7,' ')
				ELSE dbo.PreencheString([Debito],7,'0') END)[Debito],
			(Case [Credito]
				WHEN 'M' THEN dbo.PreencheString([Credito],7,' ')
				WHEN 'T' THEN dbo.PreencheString([Credito],7,' ')
				ELSE dbo.PreencheString([Credito],7,'0') END)[Credito],
			dbo.PreencheString([Valor],17,'0')[Valor],
			'00000'[Historico Padrao],
			dbo.PreencheString([Complemento],200,' ') [Complemento],
			dbo.PreencheString([CCDB],42,' ') [CCDB],
			dbo.PreencheString([CCCR],42,' ') [CCCR]
	from 
		@TAB
	
GO
