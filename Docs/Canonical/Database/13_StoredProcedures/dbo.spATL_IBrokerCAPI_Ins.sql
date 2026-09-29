SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerCAPI_Ins](
		@JOB varchar(16),
		@Order_Reference varchar(50),
		@Order_Date	datetime,
		@Code_Origin_Country	varchar(50),
		@Origin_Country	varchar(50),
		@House	varchar(50),
		@Master	varchar(50),
		@Act_Carrier_Payment_Date	datetime,
		@Gross_Weigth	decimal(15,4),
		@Net_Weigth	decimal(15,4),
		@Code_Modal_RM varchar(2),
		@Modal_Description_RM varchar(50),
		@ATA_DATE datetime,
		@chkRef		bit,
		@chkPessoa	bit,
		@chkLocal	bit,
		@chkTotal	bit,
		@chkItem	bit,
		@chkDoc		bit,
		@Status_Doc	bit,
		@ID_OUT bigint out
)
as

Declare @ID bigint

set @ID = (select Isnull(max(ID),0)+1 from IBROKER_CAPI_V2)

	insert INTO 
			IBROKER_CAPI_V2
			(
				ID,
				JOB,
				Order_Reference,
				Order_Date,
				Code_Origin_Country,
				Origin_Country,
				House,
				Master,
				Act_Carrier_Payment_Date,
				Gross_Weigth,
				Net_Weigth,
				Code_Modal_RM,
				Modal_Description_RM,
				ATA_DATE,
				chkRef		,
				chkPessoa	,
				chkLocal	,
				chkTotal	,
				chkItem	,
				chkDoc,
				Status_Doc	,
				Status
			)
	values
	(
			@ID,
			@JOB,
			@Order_Reference,
			@Order_Date,
			@Code_Origin_Country,
			@Origin_Country,
			@House,
			@Master,
			@Act_Carrier_Payment_Date,
			@Gross_Weigth,
			@Net_Weigth,
			@Code_Modal_RM,
			@Modal_Description_RM,
			@ATA_DATE,
			@chkRef		,
			@chkPessoa	,
			@chkLocal	,
			@chkTotal	,
			@chkItem	,
			@chkDoc,
			@Status_Doc	,
			1
	)

	--if @Status_Doc = 1
	--	Begin
			
	--		update Tarefas_Processos set dt_Conclusao = getdate(), cd_usuario = 'ATL'
	--		where Num_Proc = @JOB and ID_Task = '63'

	--	End
		
set @ID_OUT = @ID
GO
