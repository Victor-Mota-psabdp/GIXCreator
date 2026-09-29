SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAtualizaMiroComplementar_Upd] ---'46005295','5',1,''

			@Num_Pedido	Varchar(50),
			@Item		Varchar(10),
			@Status		bit,
			@Motivo		Varchar(100)
AS


Declare @Num_Proc Varchar(16)
Declare @Id_Miro	Varchar(10)
Declare @ValorMiro	decimal(10,2)
Declare @strCorpoMSG VArchar(Max)
Set @Num_Proc=''
Set @id_miro='0'
SEt @ValorMiro=0

--Buscando Processo

Set @Num_Proc = (select top 1 Num_Proc from pedido_ship PS Join Pedido PD on PD.cd_pedido=PS.cd_pedido where right('00000' + num_pedido,10)=right('00000'+ @Num_Pedido,10) and right('00000'+item,5)=right('00000'+@item,5))
print @Num_proc
--Busca ultima miro fatura emitida

Set @ID_MIRO=(select max(id_miro) from fmc_miro where fatura_pc=@Num_Proc and id_evento='F')
print @ID_Miro
-- Buscando valor da miro
Set @ValorMiro=(select sum(vlr_item_custo) from custo_cliente where num_nf_custo=@id_miro)
print @ValorMiro
-- Deduzindo despesas lançadas da Miro de Impostos (Capatazias e Frete)
SEt @ValorMiro=@ValorMiro-Isnull((select sum(vlr_item_Custo) from custo_cliente where num_proc=@num_proc and cd_tp_Tx in ('YDI','XDU')),0)

--Incluindo o Valor de INSS Sobre SDA

SEt @ValorMiro=@ValorMiro+32

--Atualizando Tabela FMC_Miro e Alerta
if @Num_Proc <> '' and @id_miro <> '0' and @valormiro <> 0 
	Begin
		Update FMC_Miro set Dt_Retorno=getdate(), vlr_miro=@ValorMiro where id_miro=@id_miro 

		Set @strCorpoMSG='Miro Complementar Aprovada |'
	---	Set @strCorpoMSG=@strCorpoMSG + 'BDP Ref: ' + @Num_Proc + '|'
		Set @strCorpoMSG=@strCorpoMSG + 'Valor da Miro: ' + cast(@ValorMiro as varchar(40)) + '|'
--		Set @strCorpoMSG=@strCorpoMSG + '|||' + 'sent by BDPSystem'
	
		Set @Num_Pedido=@Num_Pedido + '-' + @ITem	
		exec spLog_WebService_Ins 'Miro',@strCorpoMSG,@Num_Proc,@Num_Pedido ,null,'sistemas@bdp.com.br;pmarchesano@bdp.com.br;cmartins@bdp.com.br;klira@bdp.com.br'

	End



GO
