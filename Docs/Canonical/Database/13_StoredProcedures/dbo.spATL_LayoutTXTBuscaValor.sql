SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[spATL_LayoutTXTBuscaValor] --2,'SCAC','PNR'
(
	@Id_Campo int,
	@Campo_Busca varchar(50),
	@Valor	varchar(50)
)
As

	Declare @Query varchar(500)
		
	Declare @cId_Campo int
	Declare @Tab_Relacionada varchar(50)
	Declare @Campo_Retorno varchar(50)
	
	select @cId_Campo=Id_Campo, @Tab_Relacionada=Tab_Relacionada, @Campo_Retorno=Cod_Busca_PK from Tipo_Campo_Ordem  With(Nolock)
	where Id_Campo = @Id_Campo
	
	Set @Query = ('Select ' + @Campo_Retorno + '[Campo_Retorno] From ' +  @Tab_Relacionada + ' With(Nolock) where ' + @Campo_Busca + ' = ''' + @Valor +'''')
	print @Query
	exec (@Query)

GO
