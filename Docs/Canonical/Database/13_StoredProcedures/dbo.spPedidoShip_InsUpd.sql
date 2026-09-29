SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Alterado por Cadu - 06/03/2013 pra pegar o and CD_SELLER=@Cd_Cliente and (CD_BUYER=@CD_CLIENTE or CD_Consignee =@CD_CLIENTE)), 
e incluido pra pegar os dados pelo pedido*/
/* Alterado por Erbson - 15-08-2012: Verificar PED.dt_pedido > getdate() -360 no @Cd_Pedido */
CREATE   procedure [dbo].[spPedidoShip_InsUpd] --'43089845','00234730','990','Dow Brasil S 05042d2','EMCSR20080214001','002', '64139042'

	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Qtd	 	float,
	@Cliente	Varchar(50),
	@Num_Proc	varchar(16),
	@Item		Varchar(6),
	@Lote		varchar(30),
	@Usuario	varchar(50)
AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Cliente	varchar(10)
	Declare @Cd_Pes_Grupo varchar(10)
	Declare @Cd_Usuario varchar(10)

	Set @Cd_Usuario = (Select Cd_Usuario from Usuario where Nome_Usuario = @Usuario and Ck_Ativo=1)

	Set @Cd_Cliente = (Select top 1 Cd_pes from Pessoa where apelido = @Cliente)
	Set @Cd_Pes_Grupo =(select top 1 G.Cd_Pes_Grupo from Pessoa_LLP PL Join Grupo G on G.Cd_Pes_Grupo = PL.Cd_Pes_Grupo where Cd_Pes = @Cd_Cliente)

	Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido where Num_Pedido=@Num_Pedido and dt_pedido > getdate() -360  and (CD_SELLER=@Cd_Cliente or CD_BUYER=@CD_CLIENTE or CD_Consignee =@CD_CLIENTE))
--Set @Cd_Pedido = (select top 1 Cd_Pedido from Pedido where Num_Pedido=@Num_Pedido and dt_pedido > getdate() -360  and CD_SELLER=@Cd_Cliente and (CD_BUYER=@CD_CLIENTE or CD_Consignee =@CD_CLIENTE))
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente where cd_proc_Cliente=@Prod_ID and Cd_Cliente=@Cd_Pes_Grupo)
	Print @Cd_Cliente
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
				(
					Cd_pedido,
					Cd_Produto,
					Qty,
					Num_Proc,
					Item,
					Lote,
					Dt_Ins,
					Cd_Usuario
				)
			VALUES
				(
					@Cd_Pedido,
					@Cd_Produto,
					@Qtd,
					@Num_Proc,
					@Item,
					@Lote,
					Getdate(),
					@Cd_Usuario
				)
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
		Print 'Pedido'
--Alimenta a Tabela PO_MODAL	
	Declare @ID 		Int
	Declare @Dt_Pedido 	datetime
	Declare @Num_PO 	varchar(25)
	Declare @Customer_PO 	varchar(50)
	Declare @NP		varchar(25)

--		Set @Dt_Pedido = (select Dt_Pedido from Pedido where Num_Pedido=@Num_Pedido and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE OR Cd_Consignee = @CD_CLIENTE)and status <> 'E')
		Set @Dt_Pedido = (select Dt_Pedido from Pedido where cd_pedido = @cd_pedido and status <> 'E')
--		Set @Num_PO = (select Num_PO from Pedido where Num_Pedido=@Num_Pedido and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE OR Cd_Consignee = @CD_CLIENTE)and status <> 'E')
		Set @Num_PO = (select Num_PO from Pedido where cd_pedido = @cd_pedido and status <> 'E')
--		Set @Customer_PO = (select Customer_PO from Pedido where Num_Pedido=@Num_Pedido and (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE OR Cd_Consignee = @CD_CLIENTE)and status <> 'E')
		Set @Customer_PO = (select Customer_PO from Pedido where cd_pedido = @cd_pedido and status <> 'E')

If left(@Num_Proc,2)= 'EM'
	Begin	
            Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '3')

	IF @NP is null
	   Begin	
--Sales Order
		SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc )
	
			INSERT INTO
				PO_HEM
				(
					Num_Proc_HEM,
					ID_PO_HEM,	
					Numero_PO_HEM,
					Data_PO_HEM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end

	else

	  Begin
	     	
		Update 
			po_HEM 
		Set
			Numero_PO_HEM = @Num_Pedido,
			Data_PO_HEM = @Dt_Pedido
		Where 
			Num_Proc_HEM=@Num_Proc and ID_DC = '3'
	  end
		Print 'PO'
if @Num_PO is Not Null
	Begin	
            Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '1')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc )

			INSERT INTO
				PO_HEM
				(
					Num_Proc_HEM,
					ID_PO_HEM,	
					Numero_PO_HEM,
					Data_PO_HEM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end

	else

	  Begin
	     	
		Update 
			po_HEM 
		Set
			Numero_PO_HEM = @Num_PO,
			Data_PO_HEM = @Dt_Pedido
		Where 
			Num_Proc_HEM=@Num_Proc and ID_DC = '1'
	  end
end
		Print 'Num'
if @Customer_PO is Not Null
	Begin
            Set @NP=(select Numero_PO_HEM from po_HEM where Num_Proc_HEM=@Num_Proc and ID_DC = '9')
	
	IF @NP is null
	    Begin
		SET @ID=(select Isnull(max(id_po_HEM),0)+1 from po_HEM where Num_Proc_HEM=@Num_Proc )

			INSERT INTO
				PO_HEM
				(
					Num_Proc_HEM,
					ID_PO_HEM,	
					Numero_PO_HEM,
					Data_PO_HEM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			po_HEM 
		Set
			Numero_PO_HEM = @Customer_PO,
			Data_PO_HEM = @Dt_Pedido
		Where 
			Num_Proc_HEM=@Num_Proc and ID_DC = '9'
	  end
	end
end

		Print 'Customer'
If left(@Num_Proc,2)= 'IM'
	Begin

            Set @NP=(select Numero_PO_HIM from po_HIM where Num_Proc_HIM=@Num_Proc and ID_DC = '3')

	IF @NP is null
	   Begin		
--Sales Order
		SET @ID=(select Isnull(max(id_po_HIM),0)+1 from po_HIM where Num_Proc_HIM=@Num_Proc )
			INSERT INTO
				PO_HIM
				(
					Num_Proc_HIM,
					ID_PO_HIM,	
					Numero_PO_HIM,
					Data_PO_HIM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end
	else

	  Begin
	     	
		Update 
			po_HIM 
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
			INSERT INTO
				PO_HIM
				(
					Num_Proc_HIM,
					ID_PO_HIM,	
					Numero_PO_HIM,
					Data_PO_HIM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end
	else

	  Begin
	     	
		Update 
			po_HIM 
		Set
			Numero_PO_HIM = @Num_PO,
			Data_PO_HIM = @Dt_Pedido
		Where 
			Num_Proc_HIM=@Num_Proc and ID_DC = '1'
	  end
end

if @Customer_PO is Not Null

	Begin

            Set @NP=(select Numero_PO_HIM from po_HIM where Num_Proc_HIM=@Num_Proc and ID_DC = '9')

	IF @NP is null
	Begin
		SET @ID=(select Isnull(max(id_po_HIM),0)+1 from po_HIM where Num_Proc_HIM=@Num_Proc )
			INSERT INTO
				PO_HIM
				(
					Num_Proc_HIM,
					ID_PO_HIM,	
					Numero_PO_HIM,
					Data_PO_HIM,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			po_HIM 
		Set
			Numero_PO_HIM = @Customer_PO,
			Data_PO_HIM = @Dt_Pedido
		Where 
			Num_Proc_HIM=@Num_Proc and ID_DC = '9'
	  end
   end

end

If left(@Num_Proc,2)= 'EA'
	Begin	
            Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '3')
	IF @NP is null
	   Begin	
--Sales Order
		SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
			INSERT INTO
				PO_HEA
				(
					Num_Proc_HEA,
					ID_PO_HEA,	
					Numero_PO_HEA,
					Data_PO_HEA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEA 
		Set
			Numero_PO_HEA = @Num_Pedido,
			Data_PO_HEA = @Dt_Pedido
		Where 
			Num_Proc_HEA=@Num_Proc and ID_DC = '3'
	  end

if @Num_PO is Not Null

	Begin	
            Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '1')
	IF @NP is null

	Begin	
		SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
			INSERT INTO
				PO_HEA
				(
					Num_Proc_HEA,
					ID_PO_HEA,	
					Numero_PO_HEA,
					Data_PO_HEA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEA 
		Set
			Numero_PO_HEA = @Num_PO,
			Data_PO_HEA = @Dt_Pedido
		Where 
			Num_Proc_HEA=@Num_Proc and ID_DC = '1'
	  end
end
if @Customer_PO is Not Null
	Begin

          Set @NP=(select Numero_PO_HEA from po_HEA where Num_Proc_HEA=@Num_Proc and ID_DC = '1')
	
	IF @NP is null

	  Begin	
		SET @ID=(select Isnull(max(id_po_HEA),0)+1 from po_HEA where Num_Proc_HEA=@Num_Proc )
			INSERT INTO
				PO_HEA
				(
					Num_Proc_HEA,
					ID_PO_HEA,	
					Numero_PO_HEA,
					Data_PO_HEA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEA 
		Set
			Numero_PO_HEA = @Customer_PO,
			Data_PO_HEA = @Dt_Pedido
		Where 
			Num_Proc_HEA=@Num_Proc and ID_DC = '9'
	  end
   end
END

If left(@Num_Proc,2)= 'IA'
	Begin	
            
		Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '3')
	
	IF @NP is null
	   Begin	
--Sales Order
		SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
			INSERT INTO
				PO_HIA
				(
					Num_Proc_HIA,
					ID_PO_HIA,	
					Numero_PO_HIA,
					Data_PO_HIA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HIA 
		Set
			Numero_PO_HIA = @Num_Pedido,
			Data_PO_HIA = @Dt_Pedido
		Where 
			Num_Proc_HIA=@Num_Proc and ID_DC = '3'
	  end

if @Num_PO is Not Null
	Begin	
		Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '1')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
			INSERT INTO
				PO_HIA
				(
					Num_Proc_HIA,
					ID_PO_HIA,	
					Numero_PO_HIA,
					Data_PO_HIA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end

	else

	  Begin
	     	
		Update 
			Po_HIA 
		Set
			Numero_PO_HIA = @Num_PO,
			Data_PO_HIA = @Dt_Pedido
		Where 
			Num_Proc_HIA=@Num_Proc and ID_DC = '1'
	  end
end
if @Customer_PO is Not Null
	Begin
		Set @NP=(select Numero_PO_HIA from po_HIA where Num_Proc_HIA=@Num_Proc and ID_DC = '9')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HIA),0)+1 from po_HIA where Num_Proc_HIA=@Num_Proc )
			INSERT INTO
				PO_HIA
				(
					Num_Proc_HIA,
					ID_PO_HIA,	
					Numero_PO_HIA,
					Data_PO_HIA,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HIA 
		Set
			Numero_PO_HIA = @Customer_PO,
			Data_PO_HIA = @Dt_Pedido
		Where 
			Num_Proc_HIA=@Num_Proc and ID_DC = '9'
	  end
    end
END

If left(@Num_Proc,2)= 'EO'
	Begin	

            Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '3')
	
	IF @NP is null
	   Begin	
--Sales Order
		SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
			INSERT INTO
				PO_HEO
				(
					Num_Proc_HEO,
					ID_PO_HEO,	
					Numero_PO_HEO,
					Data_PO_HEO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEO 
		Set
			Numero_PO_HEO = @Num_Pedido,
			Data_PO_HEO = @Dt_Pedido
		Where 
			Num_Proc_HEO=@Num_Proc and ID_DC = '3'
	  end
if @Num_PO is Not Null
	Begin	

          Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '1')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
			INSERT INTO
				PO_HEO
				(
					Num_Proc_HEO,
					ID_PO_HEO,	
					Numero_PO_HEO,
					Data_PO_HEO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEO 
		Set
			Numero_PO_HEO = @Num_PO,
			Data_PO_HEO = @Dt_Pedido
		Where 
			Num_Proc_HEO=@Num_Proc and ID_DC = '1'
	  end
end
if @Customer_PO is Not Null
	Begin
          Set @NP=(select Numero_PO_HEO from po_HEO where Num_Proc_HEO=@Num_Proc and ID_DC = '9')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HEO),0)+1 from po_HEO where Num_Proc_HEO=@Num_Proc )
			INSERT INTO
				PO_HEO
				(
					Num_Proc_HEO,
					ID_PO_HEO,	
					Numero_PO_HEO,
					Data_PO_HEO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HEO 
		Set
			Numero_PO_HEO = @Customer_PO,
			Data_PO_HEO = @Dt_Pedido
		Where 
			Num_Proc_HEO=@Num_Proc and ID_DC = '9'
	  end
    end
END

If left(@Num_Proc,2)= 'IO'
	Begin

            Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '3')
	
	IF @NP is null
	   Begin		
--Sales Order
		SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,
					ID_PO_HIO,	
					Numero_PO_HIO,
					Data_PO_HIO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_Pedido,
					@Dt_Pedido,
					'3'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HIO 
		Set
			Numero_PO_HIO = @Num_Pedido,
			Data_PO_HIO = @Dt_Pedido
		Where 
			Num_Proc_HIO=@Num_Proc and ID_DC = '3'
	  end

if @Num_PO is Not Null
	Begin	


            Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '1')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,
					ID_PO_HIO,	
					Numero_PO_HIO,
					Data_PO_HIO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Num_PO,
					@Dt_Pedido,
					'1'
				)
	end

	else

	  Begin
	     	
		Update 
			Po_HIO 
		Set
			Numero_PO_HIO = @Num_PO,
			Data_PO_HIO = @Dt_Pedido
		Where 
			Num_Proc_HIO=@Num_Proc and ID_DC = '1'
	  end
end
if @Customer_PO is Not Null
	Begin


            Set @NP=(select Numero_PO_HIO from po_HIO where Num_Proc_HIO=@Num_Proc and ID_DC = '9')
	
	IF @NP is null
	   Begin	
		SET @ID=(select Isnull(max(id_po_HIO),0)+1 from po_HIO where Num_Proc_HIO=@Num_Proc )
			INSERT INTO
				PO_HIO
				(
					Num_Proc_HIO,
					ID_PO_HIO,	
					Numero_PO_HIO,
					Data_PO_HIO,
					Id_DC
				)
			VALUES
				(
					@Num_Proc,
					@ID,
					@Customer_PO,
					@Dt_Pedido,
					'9'
				)
	end
	else

	  Begin
	     	
		Update 
			Po_HIO 
		Set
			Numero_PO_HIO = @Customer_PO,
			Data_PO_HIO = @Dt_Pedido
		Where 
			Num_Proc_HIO=@Num_Proc and ID_DC = '9'
	  end
   end
end


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
		Print @Id_NCM
		      If @Id_NCM is Not Null
			  Begin	
			
		   If Not Exists (select ID_NCM from Proc_NCM where Num_Proc = @Num_Proc and ID_NCM =@Id_NCM) 
		      Begin
			SET @IDNCM=(select Isnull(max(Id_NCM_Proc),0)+1 from Proc_NCM where Num_Proc = @Num_Proc)
			Print @IDNCM
			INSERT INTO
				Proc_NCM
				(
				Id_NCM_Proc,
				Num_Proc,
				Id_NCM
				)
			VALUES
				(
				@IdNCM,
				@Num_Proc,
				@Id_NCM
				)
		     END
		END
	END
		Print 'NCM'
		
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

COMMIT TRANSACTION




GO
