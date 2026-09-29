SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE function [dbo].[fBusca_HistoricoQuebrado](
				@Processo	varchar(16),
				@Hoje		datetime,
				@Corte		int,
				@Qtd_Tab	int
)
RETURNS Varchar(1000)

BEGIN
	Declare @Resultado	Varchar(1000)
	Declare @Descricao	Varchar(1000)
	Declare @Texto		Varchar(1000)
	Declare @DataFU		Datetime
	Declare @Data		Datetime
	Declare @Tab		varchar(50)
	Declare @Contador	int
	Declare @Caracter	int

	SET @Descricao=(select top 1 HSDDescricao from hist_geral where hsgprocesso=@processo AND DISP_CLIENTE='S' order by hsgseq desc)
	SET @DataFU=(select top 1 hsgDataFU from hist_geral where hsgprocesso=@processo AND DISP_CLIENTE='S' order by hsgseq desc)
	SET @Data=(select top 1 hsgData from hist_geral where hsgprocesso=@processo AND DISP_CLIENTE='S' order by hsgseq desc)

	begin
		SET @Descricao=(select top 1 HSDDescricao from hist_geral where hsgprocesso=@Processo and disp_cliente='S' order by hsgseq desc)
		SET @DataFU=(select top 1 hsgDataFU from hist_geral where hsgprocesso=@Processo and disp_cliente='S' order by hsgseq desc)
		SET @Data=(select top 1 hsgData from hist_geral where hsgprocesso=@Processo and disp_cliente='S' order by hsgseq desc)
	end

	if @DataFU is not null and (@DataFU > @Data)
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) + ' Previsão: ' + convert(varchar(10),@DataFU,103) + ' - ' + replace(replace(@Descricao,char(13),' '),char(10),' ')
		end
	Else
		Begin
			Set @Resultado= convert(varchar(10), @Data,103) +  ' - ' + replace(replace(@Descricao,char(13),' '),char(10),' ')
		end
	
	If len(@Resultado) > @Corte and @Resultado is not null
		Begin
			set @Tab=''
			Set @Caracter = 0
			Set @Texto=''
			Set @Contador=len(@Resultado) / (@Corte) + 1

			while @Qtd_Tab > 0
				Begin
					Set @Tab = @Tab + char(9)
					Set @Qtd_Tab = @Qtd_Tab - 1
				End

			While @Contador > 0
				Begin
					If substring(@Resultado,@Corte + @Caracter,1) <> ' '
						Begin
							while substring(@Resultado,@Corte + @Caracter,1) <> ' '
								Begin
									set @Caracter = @Caracter + 1
								end
						end

						If Len(@Resultado) <= @Corte + @Caracter
							Begin						
								Set @Texto = @Texto + @Resultado + char(13)
								Set @Contador = 0
							End
						Else
							Begin
								Set @Texto = @Texto + left(@Resultado,@Corte+@Caracter) + char(13) + @Tab
								Set @Resultado=Right(@Resultado, Len(@Resultado) - @Corte - @Caracter)
							End
						Set @Contador = @Contador-1
						Set @Caracter = 0
				End
			Set @Resultado=@Texto
		End

	RETURN @Resultado

END

/*
select dbo.fBusca_HistoricoQuebrado('IMCSR20090337901',getdate(),50,14)
select Atlantis.dbo.fBusca_Historicodescr('IMDEC20090300301',0,getdate())
*/












GO
