SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	procedure [dbo].[spATL_Volume_Exp_Mar_InsUpd]
	@Num_Proc	  varchar(16),
	@Item 	      varchar(2),
	@Qtd_Vol	  Float, 
	@Embalagem	  varchar(30),
	@Comprimento  Float,
	@Largura	  Float,
	@Altura	      Float,
	@Peso_Bruto	  Float,
	@NCM		  varchar(12),
	@Marca	      varchar(2000),
	@Contra_Marca varchar(2000),
	@Volume		  Float,
	@Container    varchar(20)
AS

BEGIN TRANSACTION

	Declare @cd_tp_embal varchar(3)
	Declare @Id_NCM	int
	Declare @Item_Cont varchar(10)

	set @Item_Cont = (select CH.Item_Cont_EM from Container_Hou_Exp_Mar CH
						Join Container_Mas_Exp_Mar MAS on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM
						where CH.num_proc_hEm = @Num_Proc and MAS.Num_Cont_EM = @Container)
 
	set @cd_tp_embal = (select cd_tp_embal from tipo_embalagem where nome_tp_embal = @Embalagem)
	set @Id_NCM = (select id_ncm from NCM where ncm = @NCM)

	if exists (select Item_EM from Volume_Exp_Mar where Item_EM = @Item and Num_Proc_HEM = @Num_Proc)
		BEGIN
			UPDATE
				Volume_Exp_Mar
			SET
				Qtd_Vol_EM	    =@Qtd_Vol,
				Cd_Tp_Embal	    =@Cd_Tp_Embal,
				Compr_EM	    =@Comprimento,
				Largura_EM   	=@Largura,
				Altura_EM  	    =@Altura,
				Peso_Bruto_EM	=@Peso_Bruto,
				Id_NCM		    =@Id_NCM,
				Marca_EM	    =@Marca,
				Contra_Marca	=@Contra_Marca,
				Vol_Item_EM	    =@Volume,
				cd_tp_unidade	='M3',
				Item_Cont_EM    = @Item_Cont
			WHERE
				Item_EM = @Item and Num_Proc_HEM = @Num_Proc
		END
	ELSE
		BEGIN
			SET @Item=(select Isnull(max(Item_EM),0)+1 from Volume_Exp_Mar where Num_Proc_HEM=@Num_Proc)
			SET @Item = '0'+@Item
			SET @Item = right(@Item,2)
			INSERT INTO
				Volume_Exp_Mar
				(
					Num_Proc_HEM,
					Item_EM,
					Qtd_Vol_EM,
					Cd_Tp_Embal,
					Compr_EM,
					Largura_EM,
					Altura_EM,
					Peso_Bruto_EM,
					Id_NCM,
					Marca_EM,
					Contra_Marca,
					Vol_Item_EM,
					cd_tp_unidade,
					Item_Cont_EM
				)
			VALUES
				(
					@Num_Proc,
					@Item,
					@Qtd_Vol,
					@Cd_Tp_Embal,
					@Comprimento,
					@Largura,
					@Altura,
					@Peso_Bruto,
					@Id_NCM,
					@Marca,
					@Contra_Marca,
					@Volume,
					'M3',
					@Item_Cont
				)
		END

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
	

GO
