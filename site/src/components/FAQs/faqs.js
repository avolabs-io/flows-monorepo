import React, { useState } from "react";

const data = [
  {
    title: "What is a payment stream?",
    paragraph:
      "A payment stream is a continuous transfer of monetary value, similar to streaming music or movies but simply with money. Payment streams eliminate recurring payments through continuosly 'streaming' money.",
  },
  {
    title: "What can I do with a payment stream?",
    paragraph:
      "Payment streams have multiple use's, from paying rental payments continuously to paying salaries continuously. Any payment that requires periodic payments can be improved through continuous payment streams.",
  },
  {
    title: "Where does the money get stored?",
    paragraph:
      "The funds for transfer are stored directly in your Raiden wallet.",
  },
  {
    title: "What is Ethereum?",
    paragraph:
      "Ethereum is a global computer that allows for fully decentralized transactions in a transparent and meaningful way.",
  },
  {
    title: "What is the Raiden Network?",
    paragraph:
      "Raiden is a layer 2 solution, that is a technology built to solve some of the core problems of ethereum (layer 1). Raiden allows fast, affordable, scalable transactions for Ethereum and even allowing to do this privately.",
  },
  {
    title: "How do I create a stream?",
    paragraph:
      "This is coming soon! The project is under active development. Please follow us on twitter or join our discord to keep updated on when the application will be available for use. Check out the docs for a sneak peak into what is happenening.",
  },
];

const Accordion = () => {
  return (
    <div className="faqs-wrapper">
      <h2>FAQs</h2>
      <ul className="accordion-list">
        {data.map((data, key) => {
          return (
            <li className="accordion-list__item" key={key}>
              <AccordionItem {...data} />
            </li>
          );
        })}
      </ul>
    </div>
  );
};

const AccordionItem = ({ title, paragraph }) => {
  const [opened, setOpened] = useState(false);

  return (
    <div
      className={`accordion-item, ${opened && "accordion-item--opened"}`}
      onClick={() => {
        setOpened(!opened);
      }}
    >
      <div className="accordion-item__line">
        <h3 className="accordion-item__title">{title}</h3>
        <span className="accordion-item__icon" />
      </div>
      <div className="accordion-item__inner">
        <div className="accordion-item__content">
          <p className="accordion-item__paragraph">{paragraph}</p>
        </div>
      </div>
    </div>
  );
};

export default Accordion;
