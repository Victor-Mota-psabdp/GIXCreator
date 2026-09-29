SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spAtualizaMiroComplementarWeb_Upd] --'46005214','5',1,''

			@Num_Pedido	Varchar(50),
			@Item		Varchar(10),
			@Status		bit,
			@Motivo		Varchar(100)
AS


Declare @Num_Proc Varchar(16)
Declare @Id_Miro	int
Declare @ValorMiro	decimal(10,2)
Declare @strCorpoMSG VArchar(Max)
Set @Num_Proc=''
Set @id_miro=0
SEt @ValorMiro=0

--Buscando Processo
set @id_miro=(
select max(id_miro) from miro_item MI
Join Miro M on M.ID_Miro=MI.id_miro
Where cast(strnumpedido as int)=cast(@Num_Pedido as int)
and cast(strnumpedidoitem as int)=cast(@Item as int)
and tipo_miro='F')

Set @Num_Proc = (select top 1 strdocumentoimportacao from miro where id_miro=@id_miro )

print @Num_proc
--Busca ultima miro fatura emitida

-- Buscando valor da miro
Set @ValorMiro=(Select top 1 vlrbrutofatura from miro where id_miro=@id_miro)
print @ValorMiro
-- Deduzindo despesas lançadas da Miro de Impostos (Capatazias e Frete)
SEt @ValorMiro=@ValorMiro-Isnull((select sum(vlr_montante) from miro_item where id_miro=@id_miro),0)

/*

--Atualizando Tabela FMC_Miro e Alerta
if @Num_Proc <> '' and @id_miro <> '0' and @valormiro <> 0 
	Begin
		Update FMC_Miro set Dt_Retorno=getdate(), vlr_miro=@ValorMiro where id_miro=@id_miro 

		Set @strCorpoMSG='Miro Complementar Aprovada |'
	---	Set @strCorpoMSG=@strCorpoMSG + 'BDP Ref: ' + @Num_Proc + '|'
		Set @strCorpoMSG=@strCorpoMSG + 'Valor da Miro: ' + cast(@ValorMiro as varchar(40)) + '|'
--		Set @strCorpoMSG=@strCorpoMSG + '|||' + 'sent by BDPSystem'
	
		Set @Num_Pedido=@Num_Pedido + '-' + @ITem	
		exec Atlantis.dbo.spLog_WebService_Ins 'Miro',@strCorpoMSG,@Num_Proc,@Num_Pedido ,null,'sistemas@bdp.com.br;dpereira@bdp.com.br;bessie@bdp.com.br;pmarchesano@bdp.com.br;cmartins@bdp.com.br;klira@bdp.com.br'

	End
*/


GO
