SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[spATL_AX_DOC_Item_OracleInsUpd]
(
	@ID_AX			bigint	,
	@ID_Item		int	,
	@Num_Proc		varchar(40)	,
	@Cd_Tp_TX		varchar(40)	,
	@DC				char	,
	@Valor			decimal	(10,2),
	@Moeda			varchar(40)	,
	@Numero_House	varchar(40)	,
	@CSREmail		varchar(40)	,
	@CSRName		varchar(50)	,
	@Paridade		float	,
	@AccountType	varchar(50)	,
	@MasterBOLNbr	varchar(40)	,
	@MasterBookingNbr	varchar(35)	,
	@TaxGroup		varchar(40)	,
	@Notes			varchar(500)	,
	@Num_Proc_Master	varchar(14)	,
	@Account_Number varchar(50),
	@Invoicing		bit	,
	@citCityHallServiceCode Varchar(20),
	@citCityHallServiceDesc	Varchar(255),
	@CitTransDateNF	Datetime,
	@07Invoice		Varchar(4),
	@Dimensao_2		varchar(50),
	@DocumentNum	Varchar(30),
	@Cd_tp_TX_ATL	VArchar(3),
	@ID_Item_OutPut	Int output
)

AS
	

If @ID_Item is null 
	Begin
		Set @ID_Item_OutPut=(select isnull(MAX(id_item),0) from AX_DOC_Item_Oracle where id_ax=@ID_AX)
		Set @ID_Item_OutPut = @ID_Item_OutPut + 1
		Insert 
			AX_DOC_Item_Oracle	
				(
					ID_AX	,
					ID_Item	,
					Num_Proc	,
					Cd_Tp_TX	,
					DC	,
					Valor	,
					Moeda	,
					Numero_House	,
					CSREmail	,
					CSRName	,
					Paridade	,
					AccountType	,
					MasterBOLNbr	,
					MasterBookingNbr	,
					TaxGroup	,
					Notes	,
					Num_Proc_Master,
					Account_Number,
					Invoicing	,
					Dimensao_2,
					citCityHallServiceCode,
					citCityHallServiceDesc,
					CitTransDateNF,
					[07Invoice],
					DocumentNum,
					Cd_tp_TX_ATL	

				)
				Values
					(
						@ID_AX	,
						@ID_Item_OutPut	,
						@Num_Proc	,
						@Cd_Tp_TX	,
						@DC	,
						abs(@Valor)	,
						@Moeda	,
						@Numero_House	,
						@CSREmail	,
						@CSRName	,
						@Paridade	,
						@AccountType	,
						@MasterBOLNbr	,
						@MasterBookingNbr	,
						@TaxGroup	,
						@Notes	,
						@Num_Proc_Master,
						@Account_Number,
						@Invoicing,
						@Dimensao_2,
						@citCityHallServiceCode,
						@citCityHallServiceDesc,
						@CitTransDateNF,
						@07Invoice,
						@DocumentNum,
						@Cd_tp_TX_ATL	

					)
			End
		Else
			Begin
				Update
					AX_DOC_Item_Oracle
				Set
					DocumentNum=@DocumentNum,
					Num_Proc	=	@Num_Proc	,
					Cd_Tp_TX	=	@Cd_Tp_TX	,
					DC	=	@DC	,
					Valor	=	@Valor	,
					Moeda	=	@Moeda	,
					Numero_House	=	@Numero_House	,
					CSREmail	=	@CSREmail	,
					CSRName	=	@CSRName	,
					Paridade	=	@Paridade	,
					AccountType	=	@AccountType	,
					MasterBOLNbr	=	@MasterBOLNbr	,
					MasterBookingNbr	=	@MasterBookingNbr	,
					TaxGroup	=	@TaxGroup	,
					Notes	=	@Notes	,
					Num_Proc_Master	=	@Num_Proc_Master,
					Account_Number = @Account_Number,
					Invoicing = @Invoicing	,
					Dimensao_2 = @Dimensao_2,
					citCityHallServiceCode=citCityHallServiceCode,
					citCityHallServiceDesc=@citCityHallServiceDesc,
					CitTransDateNF=@CitTransDateNF,
					[07Invoice]=@07Invoice
				Where
					ID_AX	=	@ID_AX	and
					ID_Item	=	@ID_Item	

			End
			
	
GO
