SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spSFDC_InsUpd]
(
@ne	varchar	(	30	)	,
@SFDC_ID	varchar	(	30	)	,
@AX_SENT_ID	Varchar(20),				
@AX_Customer_VEndor	int				,
@PT	int				,
@Account_Name	varchar	(	200	)	,
@Num_Proc	varchar	(	26	)	,
@Invoice	varchar	(	40	)	,
@ATL_NF	varchar	(	25	)	,
@Charge_Code	varchar	(	3	)	,
@Charge_Descr	varchar	(	150	)	,
@TransType	varchar	(	20	)	,
@D_C	char	(	1	)	,
@Currency	char	(	3	)	,
@Amount	decimal	(	10,2	)	,
@BRL_Amount	decimal	(	10,2	)	,
@BDPCharge_Dt	varchar(10)				
)

AS
if @AX_SENT_ID=''
begin
	set @AX_SENT_ID=null
end

if exists(select * from SFDC where SFDC_ID=@SFDC_ID)
Begin
	Update
		SFDC 
	SET
		ne	=	@ne	,
		AX_SENT_ID	=	@AX_SENT_ID	,
		AX_Customer_VEndor	=	@AX_Customer_VEndor	,
		PT	=	@PT	,
		Account_Name	=	@Account_Name	,
		Num_Proc	=	@Num_Proc	,
		Invoice	=	@Invoice	,
		ATL_NF	=	@ATL_NF	,
		Charge_Code	=	@Charge_Code	,
		Charge_Descr	=	@Charge_Descr	,
		TransType	=	@TransType	,
		D_C	=	@D_C	,
		Currency	=	@Currency	,
		Amount	=	@Amount	,
		BRL_Amount	=	@BRL_Amount	,
		BDPCharge_Dt	=	@BDPCharge_Dt	,
		dt_Ins=getdate()

	Where
		SFDC_ID	=	@SFDC_ID	



end
Else

	Begin
		Insert SFDC(ne	,
SFDC_ID	,
AX_SENT_ID	,
AX_Customer_VEndor	,
PT	,
Account_Name	,
Num_Proc	,
Invoice	,
ATL_NF	,
Charge_Code	,
Charge_Descr	,
TransType	,
D_C	,
Currency	,
Amount	,
BRL_Amount	,
BDPCharge_Dt	,dt_ins 
)
values
	(
	@ne	,
@SFDC_ID	,
@AX_SENT_ID	,
@AX_Customer_VEndor	,
@PT	,
@Account_Name	,
@Num_Proc	,
@Invoice	,
@ATL_NF	,
@Charge_Code	,
@Charge_Descr	,
@TransType	,
@D_C	,
@Currency	,
@Amount	,
@BRL_Amount	,
@BDPCharge_Dt	,
GETDATE()
)
	End
GO
