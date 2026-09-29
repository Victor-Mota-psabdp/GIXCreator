SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----6230710 para 21150100
----BDP    10055103        -   88151304
----Agora passou a ser o Código despachante BDP = 88132764
--spCarregaMiroClasse_Sel

CREATE Procedure [dbo].[spCarregaMiroClasse_Sel] --spCarregaMiroClasse_Sel 'IMFMC201205015BR','F'
		@Num_Proc	Varchar(16),
		@ID_Evento	Char(1)
		
AS

Begin
	
	--Montando Cabeçalho
	Declare @DtDocumento as Datetime
	Declare @DtBasica as Datetime
	Declare @VlrBrutoFatura as Decimal(10,2)
	Declare @VlrFaturaReais as Decimal(10,2)
	Declare @strDocumentoImportacao as Varchar(16)
	Declare @StrDI as Varchar(15)
	Declare @StrNF as Varchar(50)
	Declare @StrTipoOperacao as int
	Declare @strCodigoFornecedor as Varchar(14)
	Declare @vlrParidade as float

	--Criando Tabela de Output
	Declare @tmpTable as Table
		(
			StrNumPedido					varchar(40),
			strNumPedidoItem				Varchar(10),
			vlrMontanteItem					Decimal(10,2),
			vlrMontante						Decimal(10,2),
			strNFItem						int,
			DtDocumento						Datetime,
			DtBasica						Datetime,
			VlrBrutoFatura					Decimal(10,2),
			VlrFaturaReais					Decimal(10,2),
			strNumeroDocumentoImportacao	VArchar(16),
			strDI							varchar(50),
			strNF							Varchar(50),
			StrTipoOperacao					Char(1),
			strCodigoFornecedor				Varchar(15),
			VlrParidade						Float,
			vlrQuantidade					float,
			strUOM							Varchar(3),
			strConta						Varchar(15),
			strCodigoIVA					Varchar(2),
			strDomicioFiscal				VArchar(2)
		)

	--Aplicavel para todos os casos
		Set @DtDocumento = GetDate()
		Set @strDocumentoImportacao = @Num_Proc
		
	if @ID_Evento='F'
		Begin
		
			Declare @tmpNumeroFatura as Varchar(17)
			Declare @VlrDeducoes As Decimal(10,2)
			Declare @VlrINSS as Decimal(10,2)
			Declare @tmpValor as decimal(10,2)
		
		
			Set @tmpNumeroFatura=(select MAx(fatura_pc) from Fatura_CHB where processo_pc=@Num_PRoc and Cd_Tipo='P')
		--MONTANDO VALOR DA FATURA E VALOR DA FATURA EM REAIS
				(				
					Select @VlrBrutoFatura=sum(vlr_pc),@VlrINSS =SuM(Vlr_PC*PRC_INSS) from Fatura_CHB_ITEM  FCI
					Join FMC_Plano_Contas_V2 F on F.cd_tp_Tx=FCI.cd_Tp_TX 
					Where Fatura_CC=@tmpNumeroFatura and ID_EVENTO='F'
				)
			SET @VlrDeducoes=
				Isnull((
					Select 
						sum(vlr_item_Custo) 
					from custo_Cliente 
					where 
						num_proc=@num_Proc and cd_tp_Tx in ('YDI','AFR','XDU')
						and cd_Tp_TX not in (select cd_Tp_Tx from tipo_Taxa where nome_Tp_Tx like 'AFRMM%')
				)	,0)		
			print @VlrDeducoes
			
			SET @VlrBrutoFatura=@VlrBrutoFatura-@VlrDeducoes
			set @VlrFaturaReais=@VlrBrutoFatura
		
		--Carregando Numero da DI
			SEt @StrDI=(select [dbo].[fBusca_TipoDocCliente]('N',@Num_PRoc,5))
		--Carregando variavel strNF - Nesse caso deve ser carregado o numero da PO
			SEt @StrNF=(select [dbo].[fBusca_TipoDocCliente]('N',@Num_PRoc,1))
		--Carregando @StrTipoOperacao
			Set @StrTipoOperacao=3
		--Carregando @strCodigoFornecedor = Para esses casos enviar 10055103 - codigo referente a BDP no Sistema SAP
		
		--BDP    10055103        -   88151304
		--Agora passou a ser o Código despachante BDP = 88132764

			--Set @strCodigoFornecedor='10055103'
			Set @strCodigoFornecedor='88132764'
		--Carregando Paridade - Para esses casos sempre enviar Zero
			Set @vlrParidade=0
			
		End
		
		--[dbo].[fBuscaPorcentagem_Pedido_Prod](@Num_Proc,P.cd_pedido,PS.cd_produto)
		insert @tmpTable
		SElect 
				Num_Pedido strNumPedido, PS.ITEM strNumPedidoItem,
				(@VlrFaturaReais+@VlrINSS)*[dbo].[fBuscaPorcentagem_CdProduto](@Num_Proc,ps.cd_produto)* DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) VlrMontanteItem,
				
				@VlrINSS*[dbo].[fBuscaPorcentagem_CdProduto](@Num_Proc,ps.cd_produto)* DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) vlrMontante,
				row_number() over (order by PS.Item) strNFITem, @DtDocumento DtDocumento ,@DtBasica DtBasica ,@VlrBrutoFatura  VlrBrutoFatura ,	
				@VlrFaturaReais VlrFaturaReais,	@strDocumentoImportacao strDocumentoImportacao  ,
				@StrDI StrDI ,@StrNF StrNF,	@StrTipoOperacao StrTipoOperacao,
				@strCodigoFornecedor strCodigoFornecedor,@vlrParidade vlrParidade,
				PS.Qty vlrQuantidade,UOM strUOM,
				--'6230710' strConta,
				'21150100' strConta,
				'I0' strCodigoIva,
				UF strDomicilioFiscal
				
		From
				Pedido_Ship PS with(nolock)
				Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido
				Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and PD.cd_produto=PS.cd_produto and PD.item=PS.item
				Join Endereco ED with(nolock) on ed.cd_pes=cd_buyer and Cd_Tp_End='COM'
		Where
				PS.num_proc=@Num_Proc


		--Ajustando Centavos do TOTAL
		Set @tmpValor=(select sum(vlrMontanteItem) from @tmpTable)
		if @tmpValor <>(@VlrFaturaReais+@VlrINSS)
			Begin
				Update @tmpTAble set VlrMontanteItem = VlrMontanteITem + ((@VlrFaturaReais+@VlrINSS)-@tmpValor)
				Where strNFITEM = (select max(strNFITEM) from @tmpTAble)
			
			End
			Set @tmpValor=(select sum(vlrMontante) from @tmpTable)
		if @tmpValor <>(@VlrINSS)
			Begin
				Update @tmpTAble set vlrMontante = vlrMontante + ((@VlrINSS)-@tmpValor)
				Where strNFITEM = (select max(strNFITEM) from @tmpTAble)
			
			End


		Select * From @tmpTable
End

		
		
GO
