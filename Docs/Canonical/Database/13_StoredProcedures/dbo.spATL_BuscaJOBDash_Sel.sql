SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from JOB_Dash
--select * from Modal_Dash
--spATL_BuscaJOBDash_Sel 'Consolidada','[Data Presença Carga]','IA','Grupo Dow'
CREATE procedure [dbo].[spATL_BuscaJOBDash_Sel] 

@Tipo varchar(50),
@NomeRegra varchar(50),
@Modal varchar(2)
--Filtros
--@Grupo varchar(50)
as
--Set @Tipo = 'Consolidada'
--Set @NomeRegra =  '[Data Presença Carga]'
--Set @Modal = 'IM'
--Declare @Tracking_IMP_CHB Table(
--			[Modal] varchar(5), 
--			[BDP Ref.] varchar(16), 
--			[Consol. Ref.] varchar(14), 
--			[Group] varchar(20), 
--			[Consignee] varchar(20), 
--			[CNPJ] varchar(15), 
--			[Master] varchar(25), 
--			[House] varchar(25), 
--			[P.O.] varchar(400), 
--			[Product] varchar(400), 
--			[Origin] varchar(30), 
--			[Destination] varchar(30), 
--			[Carrier] varchar(30), 
--			[Vessel / Flight #] varchar(20), 
--			[Containers / Volumes] varchar(400), 
--			[Necessidade LI?] varchar(3), 
--			[L.I.] varchar(400), 
--			[Data Solic. L.I.] datetime, 
--			[Data Def. L.I.] datetime, 
--			[Data Vcto.] datetime, 
--			[ETD Date] datetime, 
--			[ATD Date] datetime, 
--			[Data Aprov. Draft] datetime, 
--			[Data Abertura Pasta] datetime, 
--			[Data Digitação] datetime, 
--			[Data Cheg. Docs.] datetime, 
--			[Data Sol. Numerario] datetime, 
--			[Data Redest. Container] datetime, 
--			[ETA Date] datetime, 
--			[Saldo Processo Valor] float(8), 
--			[ATA Date] datetime, 
--			[Data Pgto. AFRMM] datetime, 
--			[Terminal] varchar(30), 
--			[Data Entr. Terminal] datetime, 
--			[Data Desova] datetime, 
--			[Data Presença Carga] datetime, 
--			[Data Liberação BL] datetime, 
--			[D.I.] varchar(80), 
--			[Data D.I.] datetime, 
--			[Data Desembaraço] datetime, 
--			[Data Pgto Armazenagem] datetime, 
--			[Data Pgto SDA] datetime, 
--			[Data Averbação] datetime, 
--			[Channel] varchar(20), 
--			[Data Env Draft NFe] datetime, 
--			[Data Entr Docs Transp] datetime, 
--			[Data Env Draft NF Compl] datetime, 
--			[Data Env Docs Faturamento] datetime, 
--			[Data Env. Faturamento SP] datetime, 
--			[Data Receb. Faturamento] datetime, 
--			[Data Prev Entrega] datetime, 
--			[Data Entrega Planta] datetime, 
--			[Histórico] varchar(max), 
--			[Notes (OBS)] varchar(max), 
--			[Urgente] varchar(3), 
--			[Localidade] varchar(3), 
--			[Certificado de Origem] varchar(max), 
--			[Drawback - Ato Concess.] varchar(max)
--)

--insert @Tracking_IMP_CHB
--select * from Tracking_IMP_CHB
--where ([Group] = @Grupo or @Grupo is null)

Declare @ModalD varchar(50)
if @Modal = 'IM'
set @ModalD = 'Sea Import'
if @Modal = 'IA'
set @ModalD = 'Air Import'

		Declare @Saida Table
			(
					Modal	varchar(50),
					NomeRegra varchar(50),
					QTY	Int
			)
		Declare @Saida2 Table
			(
					Modal	varchar(50),
					NomeRegra varchar(50),
					QTY	Int
			)

Declare @Busca	varchar(Max)
Declare @Operador	char
Declare @Dias	varchar(10)
Declare @DescrIngles varchar(50)

--print @Busca
--print @Operador
--print @Dias
Declare @Query varchar(max)
Declare @QTY varchar(50)

Declare @QTYTotal varchar(50)
--select @Busca,@Operador,@Dias
	if @Tipo = 'Consolidada'
		Begin
			Select @Busca = Busca,@Operador = Operador,@Dias = Dias, @DescrIngles = Descr_Ingles from JOB_Dash where Nome_Regra = @NomeRegra and Modal = @Modal
			
			Set @Query =('select top 1 '''+@ModalD+''','''+@NomeRegra+''', RANK() OVER(ORDER BY [BDP Ref.]) Linhas  from  Tracking_IMP_CHB  where substring([BDP Ref.],1,2) = '+ ''''+@Modal+'''' + ' and '+ @Busca +  'is not null' +' and '+ @NomeRegra + 'is null and '+@Busca +' <= GETDATE()'+ @Operador + @Dias + ' group by [BDP Ref.] order by 3 desc')
			print '1'+@Query
			Insert @Saida
			 exec (@Query)
			 --select * from @Saida
			set @QTY = (select QTY from @Saida)
			print @QTY		
			Set @Query = ('update Modal_Dash set ' + @DescrIngles + ' = ' + @QTY + ' where Modal = '''+@ModalD+''' and Tipo = ''Error''')
			print @QTY
			exec (@Query)
			print @Query
			Set @Query =('select top 1 '''+@ModalD+''','''+@NomeRegra+''', RANK() OVER(ORDER BY [BDP Ref.]) Linhas  from Tracking_IMP_CHB  where substring([BDP Ref.],1,2) = '+ ''''+@Modal+'''' + ' and '+ @Busca +  'is not null group by [BDP Ref.] order by 3 desc')
			print '2'+ @Query	
			Insert @Saida2
			 exec (@Query)
			set @QTY = (select QTY from @Saida2)
			Set @Query = ('update Modal_Dash set ' + @DescrIngles + ' = ' + @QTY + ' where Modal = '''+@ModalD+''' and Tipo = ''Correct''')
			exec (@Query)
			print @Query		
		End
	if @Tipo = 'Detalhado'
		Begin	
			Select @Busca = Busca,@Operador = Operador,@Dias = Dias, @NomeRegra = Nome_Regra from JOB_Dash where Descr_Ingles = @NomeRegra and Modal = @Modal
			Set @Query =('select [BDP Ref.],'+ @Busca +',DATEDIFF(DAY,'+ @Busca + ',getdate()) [Atraso (Dias)] from Tracking_IMP_CHB where substring([BDP Ref.],1,2) = '+ ''''+@Modal+'''' + ' and '+ @Busca +  'is not null' +' and '+ @NomeRegra + 'is null and '+@Busca +' <= GETDATE()'+ @Operador + @Dias + ' group by [BDP Ref.],' + @NomeRegra +','+ @Busca +' order by 3 desc')
			--print @Query
			exec (@Query)
			
		End


GO
