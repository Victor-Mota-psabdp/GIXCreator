SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select distinct tipo from contabilidade_bls

--[spATL_BLSTXTPROV_Sel] '','Doc-Register','2013-03-01','2013-03-05'

create procedure [dbo].[spATL_BLSTXTPROVTx_Sel] 
	@JOB varchar(16),
	@Tipo varchar(25),
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
	Declare @DC Varchar(1)
	Declare @Historico Varchar(300)
	Declare @JOBs Table 
						(
						JOB varchar(16),
						DC	varchar(1),
						Historico varchar(500)
						)
	EXEC [spATL_ContBLS_OutPut] @JOB,@DataInicial,@DataFinal
	
	If @JOB <> '' and @JOB is not NULL
		Begin
			Insert into @JOBs
			select num_proc JOB, DC,Historico from contabilidade_bls 
			where num_proc = @JOB and Tipo =@Tipo
			group by num_proc,DC,Historico
	End
	else
		Begin
			Insert into @JOBs
			select num_proc JOB, DC,Historico from contabilidade_bls 
			where Tipo =@Tipo and data between @DataInicial and @DataFinal 
			group by num_proc,DC,Historico
		End
	
Declare C_NumLctoDiv cursor for

--Busca Numeros do JOB conforme datas Informadas 
		Select * from @JOBs
		
Open C_NumLctoDiv 
SET NOCOUNT ON
Fetch Next From C_NumLctoDiv Into @NumLctoDiv, @DC, @Historico
	While @@FETCH_STATUS = 0
		Begin
				
---Guarda na tabela temporaria o REGISTRO TIPO 1
			Insert into @TAB
				select 
					@NumLctoDiv [Num_Lcto_Div],
					1 [Tipo de Registro],
					'MM' [Tipo de Lancamento],
					NULL [Conta Reduzida],
					NULL [Codigo Centro de Custo],
					@DC [Natureza Sub Lancamento],
					replace(substring(convert(varchar,max(Data),103),1,5),'/','')  [Data],
					sum(Valor_RS) [Valor],
					NULL [Historico Padrao],
					@Historico [Complemento]
				from contabilidade_bls  with(nolock)
				where Num_proc = @NumLctoDiv and Tipo =@TIPO and DC=@DC and Historico =@Historico-- and data between @DataInicial and @DataFinal --and IFAT.DC = 'C'

		Insert into @TAB												
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						BLS.Conta_Credito [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'C' [Natureza Sub Lancamento],
						NULL [Data],
						TAB.Valor [Valor],
						(case 
							when DC='C' then '21230' 
							else '00074'
						End
						) [Historico Padrao],
						@Historico [Complemento]
					from @TAB TAB 
					join contabilidade_bls BLS on BLS.Num_proc = TAB.Num_Lcto_Div and DC=TAB.[Natureza Sub Lancamento] and BLS.Historico=TAB.[Complemento] and Tipo =@Tipo --and BLS.data between @DataInicial and @DataFinal
					where TAB.Num_Lcto_Div = @NumLctoDiv and TAB.[Natureza Sub Lancamento] = @DC and TAB.[Complemento] = @Historico  and [Tipo de Registro] = 1
					group by TAB.Num_Lcto_Div,BLS.Conta_Credito,TAB.Valor,DC
					
---Guarda na tabela temporaria o REGISTRO TIPO 2 - DEBITO	
Insert into @TAB												
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						BLS.Conta_Debito [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'D' [Natureza Sub Lancamento],
						NULL [Data],
						TAB.Valor [Valor],
--						'21230' [Historico Padrao],
						(case 
							when DC='C' then '21230' 
							else '00074'
						End
						) [Historico Padrao],

						@Historico [Complemento]
					from @TAB TAB 
					join contabilidade_bls BLS on BLS.Num_proc = TAB.Num_Lcto_Div and DC=TAB.[Natureza Sub Lancamento] and BLS.Historico=TAB.[Complemento] and Tipo =@Tipo --and BLS.data between @DataInicial and @DataFinal
					where TAB.Num_Lcto_Div = @NumLctoDiv and TAB.[Natureza Sub Lancamento] = @DC and TAB.[Complemento] = @Historico  and [Tipo de Registro] = 1
					group by TAB.Num_Lcto_Div,BLS.Conta_Debito,TAB.Valor,DC
			
			Fetch Next From C_NumLctoDiv Into @NumLctoDiv, @DC, @Historico
		End
close C_NumLctoDiv
deallocate C_NumLctoDiv 

			update
				@TAB
				Set
					[Conta Reduzida] = replace(str([Conta Reduzida],7),' ','0')
			where
				[Tipo de Registro] = 2
				
			update
				@TAB
				Set
					[Historico Padrao] = '00000'
			where
				@Tipo = 'NF' and [Tipo de Registro] = 2
				
			update
				@TAB
				Set
					[Historico Padrao] = '00104'
			where
				@Tipo in ('PROV','FAT','Doc-Register','RA') and [Tipo de Registro] = 2
			
			update
				@TAB
				Set
					[Complemento] = NULL,
					[Natureza Sub Lancamento] = NULL
			where
				[Tipo de Registro] = 1
								
			update
				@TAB
				Set 
				[Valor] = dbo.PreencheString(replace(convert(decimal(10,2),[Valor]),'.',','),17,'0'),
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
