SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Pedido_Ship_InsUpd] 
(
	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Qtd	 	float,
	@Shipper	Varchar(50),
	@Consignee	Varchar(50),
	@Num_Proc	varchar(16),
	@Item		Varchar(6),
	@Lote		varchar(30),
	@Usuario	varchar(50)
)

AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Shipper	varchar(10)
	Declare @Cd_Consignee varchar(10)	
	Declare @Cd_Pes_Grupo varchar(10)
	Declare @Cd_Usuario varchar(10)

	Set @Cd_Usuario = (Select Cd_Usuario from Usuario with(nolock) where Nome_Usuario = @Usuario and Ck_Ativo=1)

	Set @Cd_Shipper = (Select top 1 Cd_pes from Pessoa with(nolock) where apelido = @Shipper)
	Set @Cd_Consignee = (Select top 1 Cd_pes from Pessoa with(nolock) where apelido = @Consignee)
	If left(@Num_Proc,1)= 'E'
		Set @Cd_Pes_Grupo =(select top 1 G.Cd_Pes_Grupo from Pessoa_LLP PL with(nolock) Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Shipper)
	else
		Set @Cd_Pes_Grupo =(select top 1 G.Cd_Pes_Grupo from Pessoa_LLP PL with(nolock) Join Grupo G with(nolock) on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Consignee)
	
--	Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido where Num_Pedido=@Num_Pedido and dt_pedido > getdate() -360  and (CD_SELLER=@Cd_Cliente or CD_BUYER=@CD_CLIENTE or CD_Consignee =@CD_CLIENTE))
	Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido with(nolock) where Num_Pedido=@Num_Pedido and dt_pedido > getdate() -720  and (CD_SELLER=@Cd_Shipper or Cd_Shipper = @Cd_Shipper) and (CD_BUYER=@Cd_Consignee or CD_Consignee =@Cd_Consignee))
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente with(nolock) where cd_proc_Cliente=@Prod_ID and Cd_Cliente=@Cd_Pes_Grupo)
--	Print @Cd_Cliente
	Print @Cd_Pedido
	PRint @Cd_Pedido


	IF EXISTS(SELECT PS.CD_PEDIDO FROM PEDIDO_SHIP PS 
		Where PS.cd_pedido=@cd_pedido and PS.cd_produto=@cd_produto and Num_Proc=@Num_Proc and Lote = @Lote and Item = @Item)
		BEGIN
			UPDATE
				Pedido_Ship
			SET
				Qty = @Qtd, Dt_Ins = Getdate(), Cd_Usuario = @Cd_Usuario
			WHERE
				Num_Proc = @Num_Proc and cd_pedido = @Cd_Pedido and cd_produto = @Cd_Produto
		END
	ELSE
		BEGIN		
			INSERT INTO				
				Pedido_Ship
				(Cd_pedido,Cd_Produto,Qty,Num_Proc,Item,Lote,Dt_Ins,Cd_Usuario)
			VALUES
				(@Cd_Pedido,@Cd_Produto,@Qtd,@Num_Proc,@Item,@Lote,Getdate(),@Cd_Usuario)
		END

Print 'Pedido_Ship'
--Alter Status do Pedido para Fechado
		Update 
			Pedido 
		set
			Status = 'C'			
		where 
--			Num_Pedido=@Num_Pedido and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE)
			cd_pedido = @cd_pedido
		
--Alimenta a Tabela PO_MODAL - RETIREI
--Alimenta a Tabela PO_MODAL	
		Declare @ID 			Int
		Declare @Dt_Pedido 		datetime
		Declare @Num_PO 		varchar(25)
		Declare @Customer_PO 	varchar(50)
		Declare @NP				varchar(25)


		Set @Dt_Pedido = (select Dt_Pedido from Pedido where cd_pedido = @cd_pedido and status <> 'E')
		Set @Num_PO = (select Num_PO from Pedido where cd_pedido = @cd_pedido and status <> 'E')
		Set @Customer_PO = (select Customer_PO from Pedido where cd_pedido = @cd_pedido and status <> 'E')

		--Exportação Maritima
		If left(@Num_Proc,2)= 'EM'
			BEGIN	
				Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '3')
				IF @NP is null
					Begin	
						--Sales Order
						SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)
						INSERT INTO	PO_HEM
							(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC)
						VALUES
							(@Num_Proc,	@ID,@Num_Pedido,@Dt_Pedido,'3')
					End
				ELSE
					Begin	     	
						Update PO_HEM 
						Set 
							Numero_PO_HEM = @Num_Pedido,
							Data_PO_HEM = @Dt_Pedido
						Where 
							Num_Proc_HEM=@Num_Proc and ID_DC = '3'
					End
		
				IF @Num_PO is Not Null
					Begin	
						Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '1')	
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc )
							INSERT INTO	PO_HEM
								(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC)
							VALUES
								(@Num_Proc,@ID,@Num_PO,@Dt_Pedido,'1')
							End
						ELSE
							Begin	     	
								Update PO_HEM 
								Set
									Numero_PO_HEM = @Num_PO,
									Data_PO_HEM = @Dt_Pedido
								Where 
									Num_Proc_HEM=@Num_Proc and ID_DC = '1'
							end
					End
		
				IF @Customer_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '9')	
						IF @NP is null
							Begin
								SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc)
								INSERT INTO PO_HEM
									(Num_Proc_HEM,ID_PO_HEM,Numero_PO_HEM,Data_PO_HEM,Id_DC)
								VALUES
									(@Num_Proc,@ID,@Customer_PO,@Dt_Pedido,'9')
							End
						ELSE
							Begin     	
								Update PO_HEM 
							Set
								Numero_PO_HEM = @Customer_PO,
								Data_PO_HEM = @Dt_Pedido
							Where 
								Num_Proc_HEM=@Num_Proc and ID_DC = '9'
							End
					End
			END

		--Importação Maritima
		If left(@Num_Proc,2)= 'IM'
			BEGIN			
				Set @NP=(select Numero_PO_HIM from po_HIM where Num_Proc_HIM=@Num_Proc and ID_DC = '3')
				IF @NP is null
					Begin		
						--Sales Order
						SET @ID=(select Isnull(max(id_po_HIM),0)+1 from po_HIM where Num_Proc_HIM=@Num_Proc )
						INSERT INTO	PO_HIM
							(Num_Proc_HIM,ID_PO_HIM,Numero_PO_HIM,Data_PO_HIM,Id_DC)
						VALUES
							(@Num_Proc,	@ID,@Num_Pedido,@Dt_Pedido,'3')
					End
				ELSE
					Begin	     	
						Update PO_HIM 
						Set
							Numero_PO_HIM = @Num_Pedido,
							Data_PO_HIM = @Dt_Pedido
						Where 
							Num_Proc_HIM=@Num_Proc and ID_DC = '3'
					end

				if @Num_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HIM from po_HIM where Num_Proc_HIM=@Num_Proc and ID_DC = '1')
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HIM),0)+1 from po_HIM where Num_Proc_HIM=@Num_Proc )
								INSERT INTO	PO_HIM
									(Num_Proc_HIM,ID_PO_HIM,Numero_PO_HIM,Data_PO_HIM,Id_DC)
								VALUES
									(@Num_Proc,@ID,@Num_PO,	@Dt_Pedido,	'1')
							End
						ELSE
							Begin     	
								Update PO_HIM 
								Set
									Numero_PO_HIM = @Num_PO,
									Data_PO_HIM = @Dt_Pedido
								Where 
								Num_Proc_HIM=@Num_Proc and ID_DC = '1'
							End
					End

				if @Customer_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HIM from po_HIM where Num_Proc_HIM=@Num_Proc and ID_DC = '9')

						IF @NP is null
							Begin
								SET @ID=(select Isnull(max(id_po_HIM),0)+1 from po_HIM where Num_Proc_HIM=@Num_Proc )
									INSERT INTO	PO_HIM
										(Num_Proc_HIM,ID_PO_HIM,Numero_PO_HIM,Data_PO_HIM,Id_DC)
									VALUES
									(@Num_Proc,	@ID,@Customer_PO,@Dt_Pedido,'9')
							End
						ELSE
							Begin	     	
								Update PO_HIM 
								Set
									Numero_PO_HIM = @Customer_PO,
									Data_PO_HIM = @Dt_Pedido
								Where 
									Num_Proc_HIM=@Num_Proc and ID_DC = '9'
							End
					End

			END

		--Exportacao Aerea
		If left(@Num_Proc,2)= 'EA'
			BEGIN	
			Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '3')
			IF @NP is null
				Begin	
					--Sales Order
					SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
						INSERT INTO
						PO_HEA
							(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC)
						VALUES
							(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
				end
			ELSE
				Begin	     	
					Update PO_HEA 
					Set
						Numero_PO_HEA = @Num_Pedido,
						Data_PO_HEA = @Dt_Pedido
					Where 
						Num_Proc_HEA=@Num_Proc and ID_DC = '3'
				End

			IF @Num_PO is Not Null
				Begin	
					Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '1')
					IF @NP is null
						Begin	
							SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
							INSERT INTO	PO_HEA
								(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC)
							VALUES
								(@Num_Proc,@ID,@Num_PO,@Dt_Pedido,'1')
						End
					ELSE
						Begin	     	
							Update PO_HEA 
							Set
								Numero_PO_HEA = @Num_PO,
								Data_PO_HEA = @Dt_Pedido
							Where 
								Num_Proc_HEA=@Num_Proc and ID_DC = '1'
						End
				End

			IF @Customer_PO is Not Null
				Begin
					Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '1')	
					IF @NP is null
						Begin	
							SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
							INSERT INTO PO_HEA
								(Num_Proc_HEA,ID_PO_HEA,Numero_PO_HEA,Data_PO_HEA,Id_DC)
							VALUES
								(@Num_Proc,@ID,@Customer_PO,@Dt_Pedido,'9')
						End
					ELSE
						Begin	     	
							Update Po_HEA 
							Set
								Numero_PO_HEA = @Customer_PO,
								Data_PO_HEA = @Dt_Pedido
							Where 
								Num_Proc_HEA=@Num_Proc and ID_DC = '9'
						End
				End
		END

		--Importacao Aerea
		If left(@Num_Proc,2)= 'IA'
			BEGIN            
				Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '3')	
				IF @NP is null
					Begin	
						--Sales Order
						SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
						INSERT INTO	PO_HIA
							(Num_Proc_HIA,ID_PO_HIA,Numero_PO_HIA,Data_PO_HIA,Id_DC)
						VALUES
							(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
					End
				ELSE
					Begin	     	
						Update PO_HIA 
						Set
							Numero_PO_HIA = @Num_Pedido,
							Data_PO_HIA = @Dt_Pedido
						Where 
							Num_Proc_HIA=@Num_Proc and ID_DC = '3'
					end

				IF @Num_PO is Not Null
					Begin	
						Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '1')	
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
								INSERT INTO
								PO_HIA
								(Num_Proc_HIA,ID_PO_HIA,	Numero_PO_HIA,Data_PO_HIA,Id_DC)
								VALUES
								(@Num_Proc,@ID,@Num_PO,@Dt_Pedido,'1')
							End
						ELSE
							Begin	     	
								Update Po_HIA 
								Set
									Numero_PO_HIA = @Num_PO,
									Data_PO_HIA = @Dt_Pedido
								Where 
									Num_Proc_HIA=@Num_Proc and ID_DC = '1'
								end
							end

				IF @Customer_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '9')	
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
								INSERT INTO
								PO_HIA
								(Num_Proc_HIA,ID_PO_HIA,	Numero_PO_HIA,Data_PO_HIA,Id_DC)
								VALUES
								(@Num_Proc,@ID,@Customer_PO,@Dt_Pedido,'9')
							end
						ELSE
							Begin	     	
							Update PO_HIA 
							Set
								Numero_PO_HIA = @Customer_PO,
								Data_PO_HIA = @Dt_Pedido
							Where 
								Num_Proc_HIA=@Num_Proc and ID_DC = '9'
							end
					End
			END

		--Exportacao Others
		If left(@Num_Proc,2)= 'EO'
			BEGIN
				Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '3')	
				IF @NP is null
					Begin	
						--Sales Order
						SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
						INSERT INTO	PO_HEO
							(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC)
						VALUES
							(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
					End
				ELSE
					Begin	     	
						Update Po_HEO 
						Set
							Numero_PO_HEO = @Num_Pedido,
							Data_PO_HEO = @Dt_Pedido
						Where 
							Num_Proc_HEO=@Num_Proc and ID_DC = '3'
					End

				if @Num_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '1')	
							IF @NP is null
								Begin	
									SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
									INSERT INTO PO_HEO
										(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC)
									VALUES
										(@Num_Proc,@ID,@Num_PO,@Dt_Pedido,'1')
								End
							ELSE
								Begin	     	
									Update PO_HEO 
								Set
									Numero_PO_HEO = @Num_PO,
									Data_PO_HEO = @Dt_Pedido
								Where 
									Num_Proc_HEO=@Num_Proc and ID_DC = '1'
								end
					End

				if @Customer_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '9')	
						IF @NP is null
							Begin	
							SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
							INSERT INTO PO_HEO
								(Num_Proc_HEO,ID_PO_HEO,Numero_PO_HEO,Data_PO_HEO,Id_DC)
							VALUES
								(@Num_Proc,@ID,@Customer_PO,@Dt_Pedido,'9')
							end
						ELSE
							Begin	     	
								Update PO_HEO 
								Set
									Numero_PO_HEO = @Customer_PO,
									Data_PO_HEO = @Dt_Pedido
								Where 
									Num_Proc_HEO=@Num_Proc and ID_DC = '9'
							End
					End
			END

		--Importacao Others
		If left(@Num_Proc,2)= 'IO'
			BEGIN
				Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '3')	
				IF @NP is null
					Begin		
						--Sales Order
						SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
						INSERT INTO
						PO_HIO
						(Num_Proc_HIO,ID_PO_HIO,	Numero_PO_HIO,Data_PO_HIO,Id_DC)
						VALUES
						(@Num_Proc,@ID,@Num_Pedido,@Dt_Pedido,'3')
					End
				ELSE
					Begin	     	
						Update PO_HIO 
						Set
							Numero_PO_HIO = @Num_Pedido,
							Data_PO_HIO = @Dt_Pedido
						Where 
							Num_Proc_HIO=@Num_Proc and ID_DC = '3'
					End

				if @Num_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '1')	
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
								INSERT INTO PO_HIO
									(Num_Proc_HIO,ID_PO_HIO,	Numero_PO_HIO,Data_PO_HIO,Id_DC)
								VALUES
									(@Num_Proc,@ID,@Num_PO,@Dt_Pedido,'1')
							End
						ELSE
							Begin	     	
								Update PO_HIO 
								Set
									Numero_PO_HIO = @Num_PO,
									Data_PO_HIO = @Dt_Pedido
								Where 
									Num_Proc_HIO=@Num_Proc and ID_DC = '1'
							End
					End

				if @Customer_PO is Not Null
					Begin
						Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '9')	
						IF @NP is null
							Begin	
								SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
								INSERT INTO PO_HIO
									(Num_Proc_HIO,ID_PO_HIO,	Numero_PO_HIO,Data_PO_HIO,Id_DC)
								VALUES
									(@Num_Proc,@ID,@Customer_PO,@Dt_Pedido,'9')
							end
						ELSE
							Begin	     	
								Update PO_HIO 
								Set
									Numero_PO_HIO = @Customer_PO,
									Data_PO_HIO = @Dt_Pedido
								Where 
									Num_Proc_HIO=@Num_Proc and ID_DC = '9'
						End
					End
			END

--NCM
Declare @IDNCM	int
Declare @NCM 	char(8)
Declare @Id_NCM int
--select * from pedido where num_pedido = '43089006'
--select * from Pedido_det where cd_pedido = '1001' and cd_produto =  '89'
	Set @NCM = (select top 1 NCM from Pedido_det where cd_pedido = @cd_Pedido and cd_produto = @Cd_Produto)
	Print @NCM
	Print @Cd_Pedido
	Print @Cd_Produto
	If @NCM is Not Null
		Begin
		   Set @Id_NCM = (select Id_NCM from NCM where NCM =  @NCM)
			--Print @Id_NCM
		   If @Id_NCM is Not Null
				Begin				
					If Not Exists (select ID_NCM from Proc_NCM where Num_Proc = @Num_Proc and ID_NCM =@Id_NCM) 
						Begin
							SET @IDNCM=(select Isnull(max(Id_NCM_Proc),0)+1 from Proc_NCM where Num_Proc = @Num_Proc)
							--Print @IDNCM
							INSERT INTO
								Proc_NCM
								(Id_NCM_Proc,Num_Proc,Id_NCM)
							VALUES
								(@IdNCM,@Num_Proc,@Id_NCM)
						End
				End
		End

		
		
Declare @Campo_dados as Varchar(1000)
Declare @Descr_Campo as varchar(30)
	Begin		
		set @Campo_dados = (select [dbo].[fBusca_CampoClienteDeliveryName] (@cd_pedido))
		set @Descr_Campo = (select 'Delivery Address')
		if @Campo_dados is not null
			Begin		
				exec spATL_CamposAdicionais_InsUpd @Num_Proc, @Descr_Campo, @Campo_Dados, @Cd_Usuario
			End	
	End
	
Declare @MoedaInvoice as varchar(50)		
set @MoedaInvoice =(select Moeda_invoice from vwHouse_Imp with(nolock) where Num_Proc = @Num_Proc)
		If @MoedaInvoice is Null
				Begin				
					Set @MoedaInvoice = (select cd_tp_moeda from Pedido where cd_pedido = @cd_pedido)
					if SUBSTRING(@Num_Proc,1,2) = 'IM'
					Begin
						update LLP_Imp_Mar set Cd_Moeda_Invoice = @MoedaInvoice where Num_Proc_Lim = @Num_Proc
					End
					if SUBSTRING(@Num_Proc,1,2) = 'IA'
					Begin
						update LLP_Imp_Aer set Cd_Moeda_Invoice = @MoedaInvoice where Num_Proc_Lia = @Num_Proc
					End
					if SUBSTRING(@Num_Proc,1,2) = 'IO'
					Begin
						update LLP_Imp_out set Cd_Moeda_Invoice = @MoedaInvoice where Num_Proc_Lio = @Num_Proc
					End
				End
				
	--atualizar  pelo campo_ordem o Delivery = 007-Delivery Note	
	--21	10017	S	Delivery
	DECLARE @DATA AS DATETIME

	Begin		
		set @Campo_dados = (select top 1 campo_dados from campo_ordem where cd_pedido = @cd_pedido and id_campo = 21)
		if @Campo_dados is not null
			Begin	
				SET @DATA = GETDATE()
				exec spAtualizaPOAll_InsUpd @Num_Proc, @Campo_dados, @DATA,7, @Cd_Usuario
				--@Num_Proc varchar(16),@Numero_PO Varchar(80),@Data_PO Datetime,@Id_DC int,@cd_usuario varchar(6)
			End	
	End
	
	--atualizar  pelo campo_ordem o Shipment Integration = 008-Shipment Number
	--1	1	S	Shipment Number
	Begin		
		set @Campo_dados = (select top 1 campo_dados from campo_ordem where cd_pedido = @cd_pedido and id_campo = 1)
		if @Campo_dados is not null
			Begin	
				SET @DATA = GETDATE()	
				exec spAtualizaPOAll_InsUpd @Num_Proc, @Campo_dados, @DATA,8, @Cd_Usuario
				--@Num_Proc varchar(16),@Numero_PO Varchar(80),@Data_PO Datetime,@Id_DC int,@cd_usuario varchar(6)
			End	
	End
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION




GO
