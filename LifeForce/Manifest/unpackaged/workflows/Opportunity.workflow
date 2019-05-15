<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lost_Reason_Inactivity</fullName>
        <field>Lost_Reason__c</field>
        <literalValue>Inactivity</literalValue>
        <name>Lost Reason Inactivity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Inactivity_Closure</fullName>
        <description>After X amount of time, opportunity stage is changed to &quot;closed lost.&quot;</description>
        <field>StageName</field>
        <literalValue>Closed Lost</literalValue>
        <name>Opportunity Inactivity Closure</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Closed Lost due to Inactivity</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Change opportunity stage to closed lost due to inactivity.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lost_Reason_Inactivity</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Opportunity_Inactivity_Closure</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
