SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spContainerIO_InsUpd]

	@ITEM_CONT_IO		INT,
	@Num_Proc_HIO		VarChar(16),
	@Num_Cont_IO		VarChar(15),
	@Nome_Tp_Cont		VarChar(30),
	@Num_Lacre_IO		VarChar(50),
	@Peso_Bruto_IO		float,
	@Dt_Vcto_Devol_IO 	datetime,
	@Dt_Devol_IO		datetime,
	@Inspecao char(1)

AS

BEGIN TRANSACTION

Declare 	@Cd_tp_Cont   VarChar(3)

Set @Cd_Tp_Cont =(select cd_tp_cont from tipo_container where nome_tp_cont = @nome_tp_cont)

	IF @Item_Cont_IO is NULL
--	if not exists( 
--		select * from container_hou_imp_OUT HOU
--		Where num_proc_HIO=@num_proc_HIO and Num_Cont_IO=@Num_Cont_IO
--		)
		BEGIN
			Set @Item_Cont_IO='000000000'+(select IsNULL(max(item_cont_IO),0)+1 from container_Hou_IMP_OUT where num_proc_HIO=@num_proc_HIO)
			SET @Item_Cont_IO=right(@Item_Cont_IO,10)
--Inserir Container_HOU_IMP_OUT
			Insert Container_HOU_IMP_OUT
				(
					Num_Proc_HIO,
					Num_Cont_IO,
					Cd_tp_Cont,
					Item_Cont_IO,
					Num_Lacre_IO,
					Peso_Bruto_IO,
					Dt_Vcto_Devol_IO,
					Dt_Devol_IO,
					inspecao
				)
			Values
				(
					@Num_Proc_HIO,
					@Num_Cont_IO,
					@Cd_tp_Cont,
					@Item_Cont_IO,
					@num_lacre_IO,
					@Peso_Bruto_IO,
					@Dt_Vcto_Devol_IO,
					@Dt_Devol_IO,
					@Inspecao
				)
		End
	ELSE
		BEGIN

			UPDATE 
				CONTAINER_HOU_IMP_OUT
					set
						Num_Lacre_IO=@Num_Lacre_IO,
						Cd_tp_Cont=@Cd_tp_Cont,
						Peso_Bruto_IO = @Peso_Bruto_IO,
						Dt_Vcto_Devol_IO = @Dt_Vcto_Devol_IO,
						Dt_Devol_IO = @Dt_Devol_IO,
						inspecao = @Inspecao
			WHERE
				Num_Proc_HIO = @Num_Proc_HIO and Item_Cont_IO = @Item_Cont_IO

		END


Commit Transaction 

						
						












GO
