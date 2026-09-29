SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure spATL_ReportTransformaParametros
	@ID_Alerta int
AS

Begin
/* 1º Alimenta a @Tab1 com os parametros atuais 
*/
	declare @Tab1 table (item varchar(1000),Dt datetime)
	begin
		insert @Tab1
		exec spATL_ReportDays_Sel 
	end

/* 2º Transforma a string "Parametros" da tabela Report_Email em tabela (@Tab2)
	ex: 
		de:		'GRUPO AÇOTÉCNICA','Last 10 days','Current Day'
		para:	
				GRUPO AÇOTÉCNICA
				Last 10 days
				Current Day
*/
	declare @Tab2 table (item varchar(1000))
	declare @Parametros varchar(max)
	set @Parametros = (select parametros from report_email where id_alerta = @ID_Alerta)
	begin
		insert @Tab2
		select replace(item,'''','') from dbo.fSplit(@Parametros,',')	
	end

/*3º faz um join entre as 2 tabs para conversão em datas e transforma o resultado da tabela novamente em String usando ponteiro
	Ex:
		de:		Last 10 days
		para:	2012-02-13 11:39:48.993

		O Resultado Final será: 'GRUPO AÇOTÉCNICA','2012-02-13 11:42:48','2012-02-23 11:42:48'

*/
	Declare @NovaSTR varchar(1000)
	set @NovaSTR = ''
	Declare @Temp varchar(1000)

	Declare	cTemp cursor for

	select Isnull(convert(varchar(1000),dt,120),T2.item) itens from @Tab2 T2
	left join @Tab1 T1 on T2.item = T1.item 
	where
		T2.item is not null 
	
		open cTemp
			Fetch Next From cTemp Into @Temp
			While @@FETCH_STATUS = 0
				Begin
					if @Temp <> '' and @Temp is not null
						if @NovaSTR='' 
							Begin
								Set @NovaSTR= '''' + @Temp
							End
						Else
							Begin
								Set @NovaSTR=@NovaSTR + ''',''' + @Temp
							End
						Fetch Next From cTemp Into @Temp
				End

		select  @NovaSTR + '''' Parametros

		close cTemp
		deallocate cTemp
End


GO
