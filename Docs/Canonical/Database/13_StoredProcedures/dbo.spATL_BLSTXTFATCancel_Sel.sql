SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_BLSTXTNew_Sel] 'DA2012120225',''
--[spATL_BLSTXTNew_Sel] '2','DA2012120225',''
--[spATL_BLSTXTNew_Sel] '3','DA2012120225','D'
--[spATL_BLSTXTFATCancel_Sel] 'IMBLU201305005BR','',''
--'IMCSR201302399BRA'

 CREATE procedure [dbo].[spATL_BLSTXTFATCancel_Sel] 
	@JOB varchar(16),
	@DataInicial datetime,
	@DataFinal datetime
	
AS

SET NOCOUNT ON
		Declare @TAB Table --1
				(
					[Num_Lcto_Div] varchar(17),
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
	Declare @NumLctoDiv	varchar(17)
	Declare @DC_Item Varchar(1)
	Declare @Num_Lcto_Div Varchar(17)
	Declare	@Cd_Cta_Ctb_Red varchar(7)
	
--Busca Numeros de Faturas conforme datas Informadas

	if @JOB <> '' and @JOB is not NULL
		Begin
		Declare C_NumLctoDiv cursor for
			Select FAT.FatCod Num_lcto_div from Fatura FAT with(nolock)
			join Item_Fat IFAT with(nolock) on FAT.FatCod = IFAT.FatCod
			where IFAT.num_proc = @JOB and FatStatus = '0' --and between @DataInicial and @DataFinal 
			group by FAT.FatCod
			
			
		
		--update 
		--		IFAT 
		--	set 
		--		IFAT.Vlr_Cont_Item = cast(isnull(par_moeda,1)* dbo.Valor(convert(decimal(15,2),abs(IFAT.Vlr_Org)),IFAT.DC) as decimal(10,2)) 
		--	from 
		--		Item_Fat IFAT with(nolock) 
		--		join Fatura FAT with(nolock)  on IFAT.FatCod = FAT.FatCod
		--		LEFT Join PAridade PAR with(nolock) on PAR.cd_tp_moeda=IFAT.cd_tp_moeda and cd_Tp_par='OFC' and dt_par =replace(convert(varchar(10),FAT.FatDtEmissao,105),'-','/')
		--	where  FatStatus = '0' and IFAT.Num_proc = @JOB
				End
	Else
		Begin
			Declare C_NumLctoDiv cursor for
				Select FAT.FatCod Num_lcto_div from Fatura FAT  with(nolock)
				join Item_Fat IFAT with(nolock) on FAT.FatCod = IFAT.FatCod
				where  FatStatus = '0' and FAT.fatdtemissao between @DataInicial and @DataFinal
				group by FAT.FatCod
		
			--update 
			--	IFAT 
			--set 
			--	IFAT.Vlr_Cont_Item = cast(isnull(par_moeda,1)* dbo.Valor(convert(decimal(15,2),abs(IFAT.Vlr_Org)),IFAT.DC) as decimal(10,2)) 
			--from 
			--	Item_Fat IFAT with(nolock) 
			--	join Fatura FAT with(nolock)  on IFAT.FatCod = FAT.FatCod
			--	LEFT Join PAridade PAR with(nolock) on PAR.cd_tp_moeda=IFAT.cd_tp_moeda and cd_Tp_par='OFC' and dt_par =replace(convert(varchar(10),FAT.FatDtEmissao,105),'-','/')
			--where  FatStatus = '1' and FAT.fatdtemissao between @DataInicial and @DataFinal
				
		End	
----
Open C_NumLctoDiv
SET NOCOUNT ON
Fetch Next From C_NumLctoDiv Into @NumLctoDiv
	While @@FETCH_STATUS = 0
		Begin
---Calcula Valores Por Item
/*
			update 
				IFAT 
			set 
				IFAT.Vlr_Cont_Item = cast(isnull(par_moeda,1)* dbo.Valor(convert(decimal(15,2),abs(IFAT.Vlr_Org)),IFAT.DC) as decimal(10,2)) 
			from 
				Item_Fat IFAT with(nolock) 
				join Fatura FAT with(nolock)  on IFAT.FatCod = FAT.FatCod
				LEFT Join PAridade PAR with(nolock) on PAR.cd_tp_moeda=IFAT.cd_tp_moeda and cd_Tp_par='OFC' and convert(Datetime,dt_par,105)=@DataFinal
			where 
				IFAT.FatCod = @NumLctoDiv
*/
---Calcula valores Por Fatura
			--update
			--	Fatura
			--set 
			--	Vlr_Cont = (select Sum(cast(Vlr_Cont_Item as decimal(10,2))) from Item_Fat where FatCod = @NumLctoDiv)
			--	, Dt_Cont = substring(convert(varchar,getdate(),103),4,10)
			--where
			--	FatCod = @NumLctoDiv
			Update
				Fatura
			set
				Dt_Cont_Canc = getdate()
			where
				FatCod = @NumLctoDiv
				
			--print @NumLctoDiv
---Guarda na tabela temporaria o REGISTRO TIPO 1
			Insert into @TAB
				select 
					FAT.FatCod [Num_Lcto_Div],
					1 [Tipo de Registro],
					'MM' [Tipo de Lancamento],
					NULL [Conta Reduzida],
					NULL [Codigo Centro de Custo],
					NULL [Natureza Sub Lancamento],
--					replace(substring(convert(varchar,max(FatDtVenc),103),1,5),'/','')  [Data],
					replace(substring(convert(varchar,max(fatdtemissao),103),1,5),'/','')  [Data],					
					--Sum(dbo.VerParidade(convert(varchar,FAT.FatDtVenc,103),Cd_Tp_Moeda,'OFC')* dbo.Valor(convert(decimal(15,2),IFAT.Vlr_Org),IFAT.DC))  [Valor],
					(cast(Vlr_Cont as decimal(10,2))) [Valor],
					NULL [Historico Padrao],
					--'00000' [Historico Padrao],
					NULL [Complemento]
					--@NumLctoDiv[Complemento]
				from Fatura FAT with(nolock)
				join Item_Fat IFAT with(nolock) on FAT.FatCod = IFAT.FatCod
				where FAT.FatCod = @NumLctoDiv --and IFAT.DC = 'C'
				group by FAT.FatCod ,FAT.Dt_Cont,Vlr_Cont 
				
---Guarda na tabela temporaria o REGISTRO TIPO 2 - CREDITO	
				Insert into @TAB
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						'22400' [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'D' [Natureza Sub Lancamento],
						NULL [Data],
						(TAB.Valor) [Valor],
						'00104' [Historico Padrao],
						'FAT: ' + TAB.Num_Lcto_Div + ' - ' + UPPER(max(PS.Nome_Raz_Soc)) [Complemento]
					from @TAB TAB 
					join FATURA FAT with(nolock)  on TAB.Num_Lcto_Div = FAT.FatCod
					join Pessoa PS with(nolock) on FAT.Cd_Pes = PS.Cd_Pes
					where TAB.Num_Lcto_Div = @NumLctoDiv and [Tipo de Registro] = 1 --and PRD.DC_Div = 'D'
					group by TAB.Num_Lcto_Div,TAB.Valor
					
---Guarda na tabela temporaria o REGISTRO TIPO 2 - DEBITO							
				Insert into @TAB
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						'11155' [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'C' [Natureza Sub Lancamento],
						NULL [Data],
						(TAB.Valor) [Valor],
						'00104' [Historico Padrao],
						'FAT: ' + TAB.Num_Lcto_Div + ' - ' + UPPER(max(PS.Nome_Raz_Soc)) [Complemento]
					from @TAB TAB 
					join FATURA FAT with(nolock)  on TAB.Num_Lcto_Div = FAT.FatCod
					join Pessoa PS with(nolock) on FAT.Cd_Pes = PS.Cd_Pes
					where TAB.Num_Lcto_Div = @NumLctoDiv and [Tipo de Registro] = 1 --and PRD.DC_Div = 'D'
					group by TAB.Num_Lcto_Div,TAB.Valor				
			Fetch Next From C_NumLctoDiv Into @NumLctoDiv
		End
close C_NumLctoDiv
deallocate C_NumLctoDiv 

--Ajusta informação de acordo com Layout de Saida
				
			update
				@TAB
				Set
					[Conta Reduzida] = replace(str([Conta Reduzida],7),' ','0')
			where
				[Tipo de Registro] = 2
			update
				@TAB
				Set 
				[Valor] = dbo.PreencheString(replace(convert(decimal(10,2),abs([Valor])),'.',','),17,'0'),
				[Complemento ]= RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(10),''))
				
			update
				@TAB
				Set 
				[Complemento ]= RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(9),''))
				
			update
				@TAB
				Set 
				[Complemento ]= UPPER(RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(13),'')))
	
Select * from @TAB

GO
