SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_Taxa_Modal_InsUpd]

	@cd_tp_tx		varchar(3),
	@Nome_TP_MODAL		varchar(100),	
	@Nome_Tp_Oper		varchar(30)
	

AS

Begin Transaction

Declare @Cd_Tp_Modal  as varchar(2)
Declare @Cd_Tp_Oper  as varchar(3)

	set @Cd_Tp_Modal = (select CD_TP_MODAL from Tipo_Modal_Imp_Exp where Nome_TP_MODAL = @Nome_TP_MODAL)
	set @Cd_Tp_Oper = (select Cd_Tp_Oper from Tipo_Oper where Nome_Tp_Oper = @Nome_Tp_Oper)

	
	IF  not exists(Select Cd_Tp_Tx from Tipo_Taxa_Modal where Cd_Tp_Tx = @cd_tp_tx and Cd_Tp_Modal = @Cd_Tp_Modal
		and Cd_Tp_Oper = @Cd_Tp_Oper)		
		INSERT into Tipo_Taxa_Modal
				(Cd_Tp_Tx,Cd_Tp_Modal,Cd_Tp_Oper)
			Values 
				(@cd_tp_tx, @Cd_Tp_Modal,@Cd_Tp_Oper)
		 

Commit Transaction


GO
