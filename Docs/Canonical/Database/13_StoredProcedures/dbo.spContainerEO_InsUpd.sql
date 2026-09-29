SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE       Procedure [dbo].[spContainerEO_InsUpd]

@Item_Cont_EO	varchar(3),
@Num_Proc_HEO	VarChar(16),
@Num_Cont_EO	VarChar(15),
@Nome_Tp_Cont	VarChar(30),
@Num_Lacre_EO	VarChar(50),
@Peso_Bruto_EO	float

AS

BEGIN TRANSACTION

Declare 	@Cd_tp_Cont   VarChar(3)

Set @Cd_Tp_Cont =(select cd_tp_cont from tipo_container where nome_tp_cont = @nome_tp_cont)

	if @Item_Cont_EO is null
		BEGIN
			Set @Item_Cont_EO='000'+(select IsNULL(max(item_cont_EO),0)+1 from container_Hou_EXP_OUT where num_proc_HEO=@num_proc_HEO)
			SET @Item_Cont_EO=right(@Item_Cont_EO,4)
--Inserir Container_HOU_EXP_OUT
			Insert Container_HOU_EXP_OUT
				(
					Num_Proc_HEO,
					Num_Cont_EO,
					Cd_tp_Cont,
					Item_Cont_EO,
					Num_Lacre_EO,
					Peso_Bruto_EO
				)
			Values
				(
					@Num_Proc_HEO,
					@Num_Cont_EO,
					@Cd_tp_Cont,
					@Item_Cont_EO,
					@num_lacre_EO,
					@Peso_Bruto_EO
				)
		End
	ELSE
		Begin
			UPDATE 
				CONTAINER_HOU_EXP_OUT
					set
						Num_Lacre_EO=@Num_Lacre_EO,
						Cd_tp_Cont=@Cd_tp_Cont,
						Peso_Bruto_EO = @Peso_Bruto_EO
			WHERE
				Num_Proc_HEO = @Num_Proc_HEO and Item_Cont_EO = @Item_Cont_EO
		end

Commit Transaction 

						
						











GO
